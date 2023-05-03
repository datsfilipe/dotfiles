// ==UserScript==
// @name Google Sign In Fix
// @match *.google.com
// @run-at document-start
// ==/UserScript==

const reg = /[0-9]+\.[0-9]+ Safari/;
const patchedUserAgent = navigator.userAgent.replace(reg, "0.0 Safari");
const patchedAppVersion = navigator.appVersion.replace(reg, "0.0 Safari");
Object.defineProperty(navigator, "userAgent", {
  get() {
    return patchedUserAgent;
  },
  enumerable: true,
  configurable: true,
})
Object.defineProperty(navigator, "appVersion", {
  get() {
    return patchedAppVersion;
  },
  enumerable: true,
  configurable: true,
})
