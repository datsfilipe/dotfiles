import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable } from 'astal';
import Apps from 'gi://AstalApps';
import { launcherVisible } from '../lib/state';

const escape = (str: string) =>
  str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

export default function Launcher() {
  const apps = new Apps.Apps();
  const text = Variable('');
  const cursorPos = Variable(0);
  const list = Variable<Apps.Application[]>([]);
  const blink = Variable(true).poll(500, (b) => !b);

  text.subscribe((t) => {
    blink.set(true);
    if (!t) list.set([]);
    else list.set(apps.fuzzy_query(t).slice(0, 8));
  });

  const hide = () => {
    launcherVisible.set(false);
    text.set('');
    cursorPos.set(0);
    list.set([]);
  };

  const launch = (app: Apps.Application) => {
    hide();
    app.launch();
  };

  const displayMarkup = Variable.derive([text, cursorPos, blink], (t, p, b) => {
    const escapedText = escape(t);

    if (!b) return escapedText;
    if (p >= t.length) {
      return `${escapedText}<span background="#ededed" foreground="#000000"> </span>`;
    }

    const char = t[p] || ' ';
    const before = escape(t.substring(0, p));
    const after = escape(t.substring(p + 1));

    return `${before}<span background="#ededed" foreground="#000000">${escape(char)}</span>${after}`;
  });

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
              ?.get_children()?.[0]
              ?.get_children()?.[1];

            if (entry && entry instanceof Gtk.Entry) {
              entry.grab_focus();
              blink.set(true);
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
            <overlay className="search-box">
              <label
                className="search-label"
                label={displayMarkup()}
                useMarkup={true}
                xalign={0}
                halign={Gtk.Align.FILL}
                valign={Gtk.Align.CENTER}
                vexpand={false}
                ellipsize={3}
              />
              <entry
                className="search-entry"
                text={text()}
                xalign={0}
                valign={Gtk.Align.CENTER}
                vexpand={false}
                onChanged={(self) => {
                  text.set(self.text);
                  blink.set(true);
                }}
                onNotifyCursorPosition={(self) => {
                  cursorPos.set(self.cursor_position);
                  blink.set(true);
                }}
                onActivate={() => {
                  const first = list.get()[0];
                  if (first) launch(first);
                }}
              />
            </overlay>

            <box
              className="results"
              vertical
              spacing={5}
              visible={list((l) => l.length > 0)}
            >
              {list((l) =>
                l.map((app) => (
                  <button className="item" onClick={() => launch(app)}>
                    <label
                      label={app.name}
                      xalign={0}
                      halign={Gtk.Align.START}
                    />
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
