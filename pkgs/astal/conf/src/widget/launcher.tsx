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
  const selectedIndex = Variable(0); // Track focused item
  const blink = Variable(true).poll(500, (b) => !b);

  text.subscribe((t) => {
    blink.set(true);
    // Always reset selection to top when search changes
    selectedIndex.set(0);
    if (!t) list.set([]);
    else list.set(apps.fuzzy_query(t).slice(0, 8));
  });

  const hide = () => {
    launcherVisible.set(false);
    text.set('');
    cursorPos.set(0);
    list.set([]);
    selectedIndex.set(0);
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

          // 1. Navigation: Down
          if (keyval === Gdk.KEY_Down) {
            const current = selectedIndex.get();
            const max = list.get().length - 1;
            if (current < max) selectedIndex.set(current + 1);
            return true;
          }

          // 2. Navigation: Up
          if (keyval === Gdk.KEY_Up) {
            const current = selectedIndex.get();
            if (current > 0) selectedIndex.set(current - 1);
            return true;
          }

          // 3. Action: Enter
          if (keyval === Gdk.KEY_Return || keyval === Gdk.KEY_KP_Enter) {
            const currentList = list.get();
            const currentIdx = selectedIndex.get();
            // Launch the currently selected item, or the first if index is weird
            const app = currentList[currentIdx] || currentList[0];
            if (app) launch(app);
            return true;
          }

          // 4. Action: Escape
          if (keyval === Gdk.KEY_Escape) {
            hide();
            return true;
          }

          // 5. Action: Ctrl+C
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
          <box
            className="launcher-panel"
            vertical
            widthRequest={500}
            css={list((l) =>
              l.length > 0
                ? 'border-bottom-left-radius: 0; border-bottom-right-radius: 0; border-bottom: none;'
                : '',
            )}
          >
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
                // Handled by window key-press mostly, but good backup
                onActivate={() => {
                  const currentList = list.get();
                  const app =
                    currentList[selectedIndex.get()] || currentList[0];
                  if (app) launch(app);
                }}
              />
            </overlay>
          </box>
        </box>

        <overlay vexpand>
          <eventbox vexpand onClick={hide} />

          <box halign={Gtk.Align.CENTER} valign={Gtk.Align.START} vertical>
            <box
              className="launcher-panel"
              vertical
              widthRequest={500}
              spacing={5}
              visible={list((l) => l.length > 0)}
              css="margin-top: -1px; border-top-left-radius: 0; border-top-right-radius: 0; border-top: none;"
            >
              <box
                halign={Gtk.Align.CENTER}
                vexpand={false}
                widthRequest={498}
                css="min-height: 1px; background-color: #343434; margin: 2px 0;"
              />

              <box className="results" vertical spacing={5}>
                {list((l) =>
                  l.map((app, i) => (
                    <button
                      className={selectedIndex((s) =>
                        s === i ? 'item selected' : 'item',
                      )}
                      onClick={() => launch(app)}
                    >
                      <box spacing={10}>
                        <label
                          label={app.name}
                          xalign={0}
                          halign={Gtk.Align.START}
                          hexpand
                          ellipsize={3}
                        />
                        <label
                          label={app.description || ''}
                          visible={!!app.description}
                          halign={Gtk.Align.END}
                          maxWidthChars={30}
                          ellipsize={3}
                          className="description"
                        />
                      </box>
                    </button>
                  )),
                )}
              </box>
            </box>
          </box>
        </overlay>
      </box>
    </window>
  );
}
