#!/usr/bin/env nu
# vivaldi_actions_manager.nu
# Backup/restore Preferences.vivaldi.actions for Vivaldi. Backup mode also
# syncs $REPO_BACKUP with git (pull, reset, add changed files, push) if it
# is a git repo and there is something new to commit.
#
# Usage:
#   nu vivaldi_actions_manager.nu --backup
#   nu vivaldi_actions_manager.nu --apply [--force]
#
# Repo dir: $REPO_BACKUP (defaults to ~/.local/share/vivaldi-backup)
# Data files live under $REPO_BACKUP/data
# Preferences path: ~/.config/vivaldi/$VIVALDI_PROFILE/Preferences (profile defaults to "Default")
# Version priority: $VIVALDI_VERSION > Preferences.browser.last_known_version > Preferences.last_known_version

const ACTIONS_FILENAME = "actions.json"
const CHECKSUM_FILENAME = "actions.vivaldi.sha256"
const VERSION_FILENAME = "vivaldi.version"
const DEFAULT_REPO_DIR = "~/.local/share/vivaldi-backup"

def is-set [val] {
    ($val != null) and ($val != "")
}

def atomic-write [target: string, content: string] {
    let dir = ($target | path dirname)
    mkdir $dir
    let tmp = ($dir | path join $".($target | path basename).(random uuid).tmp")
    $content | save --force $tmp
    mv $tmp $target
}

def get-preferences-path [] {
    let profile = ($env.VIVALDI_PROFILE? | default "Default")
    $"~/.config/vivaldi/($profile)/Preferences" | path expand
}

def resolve-repo-dir [] {
    let env_repo = ($env.REPO_BACKUP? | default "")
    let chosen = if (is-set $env_repo) { $env_repo } else { $DEFAULT_REPO_DIR }
    $chosen | path expand
}

# Preferences has no .json extension, so `open` won't auto-parse it.
def read-preferences [prefs_path: string] {
    if not ($prefs_path | path exists) {
        print -e $"Error: file not found: ($prefs_path)"
        exit 1
    }
    try {
        open --raw $prefs_path | from json
    } catch { |err|
        print -e $"Error: failed to parse JSON in ($prefs_path): ($err.msg)"
        exit 1
    }
}

def resolve-current-version [prefs: record] {
    let env_version = ($env.VIVALDI_VERSION? | default "")
    if (is-set $env_version) {
        $env_version
    } else {
        let nested = ($prefs.browser?.last_known_version?)
        if (is-set $nested) {
            $nested
        } else {
            ($prefs.last_known_version? | default "")
        }
    }
}

# Sync $repo_dir with git: pull, reset staging, add the given files, commit
# and push only if something actually changed. No-op if not a git repo.
def sync-git-backup [repo_dir: string, files: list<string>] {
    if not ($"($repo_dir)/.git" | path exists) {
        return
    }

    let pull = (^git -C $repo_dir pull | complete)
    if $pull.exit_code != 0 {
        print -e $"Warning: git pull failed: ($pull.stderr | str trim)"
    }

    ^git -C $repo_dir reset | complete | ignore

    let existing = ($files | where {|f| $f | path exists})
    if ($existing | is-empty) {
        return
    }

    let add = (^git -C $repo_dir add ...$existing | complete)
    if $add.exit_code != 0 {
        print -e $"Warning: git add failed: ($add.stderr | str trim)"
        return
    }

    let diff = (^git -C $repo_dir diff --cached --quiet | complete)
    if $diff.exit_code == 0 {
        print "Git: no changes to commit."
        return
    }

    let msg = $"Backup vivaldi actions - (date now | format date '%Y-%m-%d %H:%M:%S')"
    let commit = (^git -C $repo_dir commit -m $msg | complete)
    if $commit.exit_code != 0 {
        print -e $"Warning: git commit failed: ($commit.stderr | str trim)"
        return
    }

    let push = (^git -C $repo_dir push | complete)
    if $push.exit_code != 0 {
        print -e $"Warning: git push failed: ($push.stderr | str trim)"
    } else {
        print "Git: changes pushed to remote."
    }
}

def do-backup [backup_dir: string, repo_dir: string] {
    let prefs_path = (get-preferences-path)
    let actions_path = ($backup_dir | path join $ACTIONS_FILENAME)
    let checksum_path = ($backup_dir | path join $CHECKSUM_FILENAME)
    let version_path = ($backup_dir | path join $VERSION_FILENAME)

    print $"Reading preferences from: ($prefs_path)"
    let prefs = (read-preferences $prefs_path)

    let vivaldi_section = ($prefs.vivaldi?)
    if ($vivaldi_section == null) {
        print -e $"Error: 'vivaldi' section not found in ($prefs_path)"
        exit 1
    }

    let actions_data = ($vivaldi_section.actions?)
    if ($actions_data == null) {
        print -e $"Error: 'vivaldi.actions' not found in ($prefs_path)"
        exit 1
    }

    mkdir $backup_dir

    let actions_json = ($actions_data | to json --indent 2)
    atomic-write $actions_path $actions_json

    let checksum = ($actions_json | hash sha256)
    atomic-write $checksum_path $"($checksum)  ($ACTIONS_FILENAME)\n"

    print $"Backup directory:           ($backup_dir)"
    print $"Saved 'vivaldi.actions' to: ($actions_path)"
    print $"Saved checksum to:          ($checksum_path)"
    print $"SHA256: ($checksum)"

    let version = (resolve-current-version $prefs)
    if (is-set $version) {
        atomic-write $version_path $"($version)\n"
        print $"Saved browser version '($version)' to: ($version_path)"
    } else {
        print -e "Warning: could not determine Vivaldi browser version; version check will be skipped on apply."
    }

    sync-git-backup $repo_dir [$actions_path $checksum_path $version_path]
}

def do-apply [backup_dir: string, force: bool] {
    let prefs_path = (get-preferences-path)
    let actions_path = ($backup_dir | path join $ACTIONS_FILENAME)
    let checksum_path = ($backup_dir | path join $CHECKSUM_FILENAME)
    let version_path = ($backup_dir | path join $VERSION_FILENAME)

    if not ($actions_path | path exists) {
        print -e $"Error: backup file not found: ($actions_path)"
        exit 1
    }

    print $"Reading preferences from: ($prefs_path)"
    let prefs = (read-preferences $prefs_path)

    let current_version = (resolve-current-version $prefs)
    let stored_version = if ($version_path | path exists) {
        (open --raw $version_path | str trim)
    } else {
        ""
    }

    if not (is-set $stored_version) {
        print -e $"Warning: no stored version found at ($version_path); skipping version check."
    } else if not (is-set $current_version) {
        print -e "Warning: could not determine current browser version; skipping version check."
    } else if $current_version != $stored_version {
        if not $force {
            print -e $"Error: Vivaldi version mismatch.\n  backup version:  ($stored_version)\n  current version: ($current_version)\nRe-run with --force / -f to override."
            exit 1
        }
        print -e $"Warning: version mismatch \(backup: ($stored_version), current: ($current_version)\); proceeding due to --force."
    } else {
        print $"Browser version matches: ($current_version)"
    }

    let actions_raw = (open --raw $actions_path)

    if ($checksum_path | path exists) {
        let expected_line = (open --raw $checksum_path | str trim)
        let expected_checksum = ($expected_line | split row " " | first)
        let actual_checksum = ($actions_raw | hash sha256)
        if $expected_checksum != $actual_checksum {
            print -e $"Error: checksum mismatch for ($actions_path)\n  expected: ($expected_checksum)\n  actual:   ($actual_checksum)"
            exit 1
        }
        print $"Checksum verified: ($actual_checksum)"
    } else {
        print -e $"Warning: no checksum file found at ($checksum_path), skipping verification."
    }

    let actions_data = try {
        $actions_raw | from json
    } catch { |err|
        print -e $"Error: failed to parse JSON in ($actions_path): ($err.msg)"
        exit 1
    }

    let safety_copy = $"($prefs_path).bak"
    try {
        cp $prefs_path $safety_copy
        print $"Original preferences backed up to: ($safety_copy)"
    } catch {
        print -e $"Warning: could not create safety copy at ($safety_copy)"
    }

    let vivaldi_section = ($prefs.vivaldi? | default {})
    let new_vivaldi = ($vivaldi_section | upsert actions $actions_data)
    let new_prefs = ($prefs | upsert vivaldi $new_vivaldi)

    atomic-write $prefs_path ($new_prefs | to json --indent 3)
    print $"Applied 'vivaldi.actions' into: ($prefs_path)"
}

def main [
    --backup(-b)
    --apply(-a)
    --force(-f)
] {
    if $backup and $apply {
        print -e "Error: --backup and --apply are mutually exclusive."
        exit 2
    }
    if (not $backup) and (not $apply) {
        print -e "Error: one of --backup / -b or --apply / -a is required."
        exit 2
    }
    if $force and (not $apply) {
        print -e "Error: --force / -f is only valid together with --apply / -a."
        exit 2
    }

    let repo_dir = (resolve-repo-dir)
    let backup_dir = ($repo_dir | path join "data")

    if $backup {
        do-backup $backup_dir $repo_dir
    } else {
        do-apply $backup_dir $force
    }
}
