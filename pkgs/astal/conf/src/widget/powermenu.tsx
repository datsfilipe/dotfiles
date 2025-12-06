import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable, bind } from 'astal';
import { execAsync } from 'astal/process';
import GdkPixbuf from 'gi://GdkPixbuf';
import GLib from 'gi://GLib';
import { powerMenuVisible } from '../lib/state';

const gifPulse = Variable(false);

export default function PowerMenu(gifFilename: string) {
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
          const [okState, state] = event.get_state();
          if (!okKey) return false;
          if (keyval === Gdk.KEY_Escape) {
            hide();
            return true;
          }
          if (
            okState &&
            state & Gdk.ModifierType.CONTROL_MASK &&
            keyval === Gdk.KEY_c
          ) {
            hide();
            return true;
          }
          return false;
        });

        self.hook(powerMenuVisible, () => {
          if (powerMenuVisible.get()) self.grab_focus();
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
            <box
              className="powermenu"
              vertical
              spacing={15}
              onButtonPressEvent={() => true}
            >
              <button
                onClick={() => run('systemctl poweroff')}
                tooltipText="Shutdown"
              >
                <label className="icon" label="" />
              </button>
              <button
                onClick={() => run('systemctl reboot')}
                tooltipText="Reboot"
              >
                <label className="icon" label="" />
              </button>

              <button
                className={bind(gifPulse).as((p) =>
                  p ? 'pulsing gif-btn' : 'gif-btn',
                )}
                onClick={triggerGif}
                tooltipText="is it GIF or GIF?"
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

              <button
                onClick={() => run('systemctl suspend')}
                tooltipText="Suspend"
              >
                <label className="icon" label="󰒲" />
              </button>
              <button
                onClick={() => run('niri msg action quit -s')}
                tooltipText="Logout"
              >
                <label className="icon" label="" />
              </button>
            </box>
          </box>
        </eventbox>
      </box>
    </window>
  );
}
