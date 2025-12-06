#!/usr/bin/env -S ags run
import { App } from 'astal/gtk3';
import { exec } from 'astal/process';
import { readFile, writeFile } from 'astal/file';
import GLib from 'gi://GLib';
import Bar from './widget/bar';
import Launcher from './widget/launcher';
import PowerMenu from './widget/powermenu';
import Notifications from './widget/notifications';
import { launcherVisible, powerMenuVisible } from './lib/state';

const SCSS_TMP = '/tmp/modified_styles.scss';
const CSS_OUT = '/tmp/style.css';
const STYLES_SRC = './styles.scss';
const VARS_SRC = `${GLib.get_home_dir()}/.local/share/astal/variables.scss`;

const LAUNCHER_CURSOR_COLOR = GLib.getenv('LAUNCHER_CURSOR_COLOR') || '#fefefe';

try {
  let content = '';
  if (GLib.file_test(STYLES_SRC, GLib.FileTest.EXISTS)) {
    const stylesContent = readFile(STYLES_SRC);
    if (GLib.file_test(VARS_SRC, GLib.FileTest.EXISTS)) {
      content += readFile(VARS_SRC) + '\n';
      const lines = stylesContent.split('\n');
      content += lines.slice(12).join('\n');
    } else {
      content = stylesContent;
    }
    writeFile(SCSS_TMP, content);
    exec(`sass ${SCSS_TMP} ${CSS_OUT}`);
  }
} catch (e) {
  console.error('Error compiling SCSS:', e);
}

App.start({
  instanceName: 'bar',
  css: CSS_OUT,
  requestHandler(request, res) {
    if (request === 'launcher') {
      launcherVisible.set(!launcherVisible.get());
      res('ok');
    } else if (request === 'powermenu') {
      powerMenuVisible.set(!powerMenuVisible.get());
      res('ok');
    } else {
      res('unknown command');
    }
  },
  main() {
    Bar(0);
    Bar(1);
    Launcher(LAUNCHER_CURSOR_COLOR);
    PowerMenu();
    Notifications(0);
  },
});
