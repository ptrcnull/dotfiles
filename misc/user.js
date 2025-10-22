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

// fuck off Pocket
user_pref("extensions.pocket.enabled", false);

// i know how about:config works
user_pref("browser.aboutConfig.showWarning", false);

// let me debug the browser
user_pref("devtools.debugger.remote-enabled", true);

// persist network logs between page changes
user_pref("devtools.netmonitor.persistlog", true);

// always show the downloads button
user_pref("browser.download.autohideButton", false);

// telemetrussy
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);

// don't autohide top bar on full screen
user_pref("browser.fullscreen.autohide", false);

// fuck off with the AI
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.ml.chat.page", false);
