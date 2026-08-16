{ pkgs, dirs, ... }:

pkgs.writeShellApplication {
  name = "volume-control";

  runtimeInputs = with pkgs; [
    wireplumber
    libnotify
    bc
  ];

  text = ''
    iDIR="${dirs.assets}/icons"

    # Get Volume (sink, as integer percentage)
    get_volume() {
    	volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
    	volume=$(printf "%.0f" "$(echo "$volume * 100" | bc)")
    	echo "$volume"
    }

    # Is sink muted?
    is_muted() {
    	wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"
    }

    # Is source (mic) muted?
    is_mic_muted() {
    	wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"
    }

    # Get icons
    get_icon() {
    	current=$(get_volume)
    	if [[ "$current" -eq "0" ]]; then
    		echo "$iDIR/volume-mute.png"
    	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
    		echo "$iDIR/volume-low.png"
    	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
    		echo "$iDIR/volume-mid.png"
    	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
    		echo "$iDIR/volume-high.png"
    	fi
    }

    # Notify
    notify_user() {
    	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume : $(get_volume) %"
    }

    # Increase Volume
    inc_volume() {
    	wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify_user
    }

    # Decrease Volume
    dec_volume() {
    	wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify_user
    }

    # Toggle Mute
    toggle_mute() {
    	if ! is_muted; then
    		wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
    	else
    		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON"
    	fi
    }

    # Toggle Mic
    toggle_mic() {
    	if ! is_mic_muted; then
    		wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone-mute.png" "Microphone Switched OFF"
    	else
    		wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone.png" "Microphone Switched ON"
    	fi
    }

    # Get mic icon
    get_mic_icon() {
    	current=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2}')
    	current=$(printf "%.0f" "$(echo "$current * 100" | bc)")
    	if [[ "$current" -eq "0" ]]; then
    		echo "$iDIR/microphone.png"
    	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
    		echo "$iDIR/microphone.png"
    	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
    		echo "$iDIR/microphone.png"
    	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
    		echo "$iDIR/microphone.png"
    	fi
    }

    # Notify mic
    notify_mic_user() {
    	current=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2}')
    	current=$(printf "%.0f" "$(echo "$current * 100" | bc)")
    	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_mic_icon)" "Mic-Level : $current %"
    }

    # Increase MIC Volume
    inc_mic_volume() {
    	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ && notify_mic_user
    }

    # Decrease MIC Volume
    dec_mic_volume() {
    	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%- && notify_mic_user
    }

    # Execute accordingly
    if [[ "''${1:-}" == "--get" ]]; then
    	get_volume
    elif [[ "''${1:-}" == "--inc" ]]; then
    	inc_volume
    elif [[ "''${1:-}" == "--dec" ]]; then
    	dec_volume
    elif [[ "''${1:-}" == "--toggle" ]]; then
    	toggle_mute
    elif [[ "''${1:-}" == "--toggle-mic" ]]; then
    	toggle_mic
    elif [[ "''${1:-}" == "--get-icon" ]]; then
    	get_icon
    elif [[ "''${1:-}" == "--get-mic-icon" ]]; then
    	get_mic_icon
    elif [[ "''${1:-}" == "--mic-inc" ]]; then
    	inc_mic_volume
    elif [[ "''${1:-}" == "--mic-dec" ]]; then
    	dec_mic_volume
    else
    	get_volume
    fi
  '';
}
