import { App } from './js/imports.js'
import Bar from './js/bar/Bar.js'
import PowerMenu from './js/powermenu/PowerMenu.js'
import Verification from './js/powermenu/Verification.js'
import AppLauncher from './js/applauncher/AppLauncher.js'
import { Utils } from './js/imports.js'

App.resetCss()

const scss = `${App.configDir}/scss/main.scss`
const css = `${App.configDir}/style.css`
Utils.exec(`sassc ${scss} ${css}`)

App.applyCss(css)

App.config({
  windows: [Bar(), PowerMenu(), Verification(), AppLauncher()],
})
