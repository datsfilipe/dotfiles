import { App } from './js/imports.js';
import Bar from './js/bar/Bar.js';
import PowerMenu from './js/powermenu/PowerMenu.js'
import Verification from './js/powermenu/Verification.js'

App.resetCss();
App.applyCss(App.configDir + '/style.css');

export default {
  windows: [
    Bar(),
    PowerMenu(),
    Verification(),
  ],
};
