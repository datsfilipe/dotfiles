import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable } from 'astal';
import Apps from 'gi://AstalApps';
import { launcherVisible } from '../lib/state';

export default function Launcher() {
  const apps = new Apps.Apps();
  const text = Variable('');
  const list = Variable<Apps.Application[]>([]);

  text.subscribe((t) => {
    if (!t) list.set([]);
    else list.set(apps.fuzzy_query(t).slice(0, 8));
  });

  const hide = () => {
    launcherVisible.set(false);
    text.set('');
    list.set([]);
  };

  const launch = (app: Apps.Application) => {
    hide();
    app.launch();
  };

  return (
    <window
      name="launcher"
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.BOTTOM |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.EXCLUSIVE}
      visible={launcherVisible()}
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

        self.hook(launcherVisible, () => {
          if (launcherVisible.get()) {
            const entry = self
              .get_child()
              ?.get_children()?.[1]
              ?.get_children()?.[0]
              ?.get_children()?.[0];
            if (entry && entry instanceof Gtk.Entry) {
              entry.grab_focus();
            }
          }
        });
      }}
    >
      <box
        className="launcher-backdrop"
        vertical
        valign={Gtk.Align.FILL}
        halign={Gtk.Align.FILL}
      >
        <eventbox vexpand onClick={hide} />

        <box halign={Gtk.Align.CENTER} vertical>
          <box className="launcher-panel" vertical widthRequest={500}>
            <entry
              className="search"
              placeholderText="Search..."
              text={text()}
              xalign={0.5}
              onChanged={(self) => text.set(self.text)}
              onActivate={() => {
                const first = list.get()[0];
                if (first) launch(first);
              }}
            />

            <box className="results" vertical spacing={5}>
              {list((l) =>
                l.map((app) => (
                  <button className="item" onClick={() => launch(app)}>
                    <label label={app.name} />
                  </button>
                )),
              )}
            </box>
          </box>
        </box>

        <eventbox vexpand valign={Gtk.Align.FILL} onClick={hide} />
      </box>
    </window>
  );
}
