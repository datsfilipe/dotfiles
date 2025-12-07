import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable, bind } from 'astal';
import { execAsync } from 'astal/process';
import GdkPixbuf from 'gi://GdkPixbuf';
import GLib from 'gi://GLib';
import { powerMenuVisible } from '../lib/state';

const gifPulse = Variable(false);

export default function PowerMenu(gifFilename: string) {
  const selectedIndex = Variable(0);
  const hide = () => powerMenuVisible.set(false);

  const run = (cmd: string) => {
    hide();
    execAsync(cmd).catch(console.error);
  };

  const triggerGif = () => {
    gifPulse.set(true);
    setTimeout(() => gifPulse.set(false), 150);
  };

  const currentDir = GLib.get_current_dir();
  const gifPath = GLib.build_filenamev([currentDir, `assets/${gifFilename}`]);

  const items = [
    { label: 'Shutdown', icon: '', cmd: 'systemctl poweroff' },
    { label: 'Reboot', icon: '', cmd: 'systemctl reboot' },
    { id: 'gif', action: triggerGif, tooltip: 'is it GIF or GIF?' },
    { label: 'Suspend', icon: '󰒲', cmd: 'systemctl suspend' },
    { label: 'Logout', icon: '', cmd: 'niri msg action quit -s' },
  ];

  return (
    <window
      name="powermenu"
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.BOTTOM |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.EXCLUSIVE}
      visible={powerMenuVisible()}
      application={App}
      setup={(self) => {
        self.connect('key-press-event', (_, event) => {
          const [okKey, keyval] = event.get_keyval();
          if (!okKey) return false;

          if (keyval === Gdk.KEY_Escape) {
            hide();
            return true;
          }

          if (keyval === Gdk.KEY_Up || keyval === Gdk.KEY_Left) {
            const current = selectedIndex.get();
            selectedIndex.set(current > 0 ? current - 1 : items.length - 1);
            return true;
          }

          if (keyval === Gdk.KEY_Down || keyval === Gdk.KEY_Right) {
            const current = selectedIndex.get();
            selectedIndex.set(current < items.length - 1 ? current + 1 : 0);
            return true;
          }

          if (
            keyval === Gdk.KEY_Return ||
            keyval === Gdk.KEY_KP_Enter ||
            keyval === Gdk.KEY_space
          ) {
            const item = items[selectedIndex.get()];
            if (item.action) item.action();
            else if (item.cmd) run(item.cmd);
            return true;
          }

          return false;
        });

        self.hook(powerMenuVisible, () => {
          if (powerMenuVisible.get()) {
            self.grab_focus();
            selectedIndex.set(0);
          }
        });
      }}
    >
      <box
        className="powermenu-backdrop"
        halign={Gtk.Align.FILL}
        valign={Gtk.Align.FILL}
      >
        <eventbox onClick={hide} hexpand vexpand>
          <box halign={Gtk.Align.END} valign={Gtk.Align.CENTER} marginEnd={20}>
            <box className="powermenu" vertical spacing={15}>
              {items.map((item, i) => {
                if (item.id === 'gif') {
                  const classNameBinding = Variable.derive(
                    [gifPulse, selectedIndex],
                    (p, s) =>
                      `${p ? 'pulsing gif-btn' : 'gif-btn'}${
                        s === i ? ' focused' : ''
                      }`,
                  )();

                  return (
                    <button
                      className={classNameBinding}
                      onClick={item.action}
                      tooltipText={item.tooltip}
                      setup={(self) => {
                        try {
                          const anim =
                            GdkPixbuf.PixbufAnimation.new_from_file(gifPath);
                          const image = Gtk.Image.new_from_animation(anim);
                          image.halign = Gtk.Align.CENTER;
                          self.add(image);
                          self.show_all();
                        } catch (e) {
                          console.error(`Failed to load GIF at ${gifPath}:`, e);
                        }
                      }}
                    />
                  );
                }

                return (
                  <button
                    className={selectedIndex((s) => (s === i ? 'focused' : ''))}
                    onClick={() => item.cmd && run(item.cmd)}
                    tooltipText={item.label}
                  >
                    <label className="icon" label={item.icon || ''} />
                  </button>
                );
              })}
            </box>
          </box>
        </eventbox>
      </box>
    </window>
  );
}
