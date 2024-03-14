// disable built-in password manager - we use bitwarden anyway
user_pref("signon.rememberSignons", false);

// glorious user chrome css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// !! (TODO: remove later)
user_pref("image.jxl.enabled", true);

// global debugger
user_pref("devtools.chrome.enabled", true);

// don't hide the address bar on full screen
user_pref("browser.fullscreen.autohide", false);

