import { App } from './js/imports.js';
import Bar from './js/bar/Bar.js';
import PowerMenu from './js/powermenu/PowerMenu.js'
import Verification from './js/powermenu/Verification.js'

export default {
  style: App.configDir + '/style.css',
  windows: [
    Bar(),
    PowerMenu(),
    Verification(),
  ],
};
