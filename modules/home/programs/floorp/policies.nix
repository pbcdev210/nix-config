{ ... }:
{
  Preferences = {
    "extensions.autoDisableScopes" = 0;
    "browser.ctrlTab.sortByRecentlyUsed" = true;

    "browser.tabs.allow_transparent_browser" = true;

    "browser.startup.page" = 3;

    "floorp.keyboardshortcut.config" = builtins.readFile ./shortcuts.json;
  };

  TranslateEnabled = true;
  AutofillAddressEnabled = true;
  AutofillCreditCardEnabled = false;

  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableTelemetry = true;

  DontCheckDefaultBrowser = true;
  NoDefaultBookmarks = true;

  OfferToSaveLogins = false;
}
