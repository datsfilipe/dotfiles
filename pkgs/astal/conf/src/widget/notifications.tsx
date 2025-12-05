import { Astal, Gtk } from 'astal/gtk3';
import Notifd from 'gi://AstalNotifd';
import { bind, GLib } from 'astal';

const time = (t: number) =>
  GLib.DateTime.new_from_unix_local(t).format('%H:%M')!;

export default function Notifications(monitor: number) {
  const notifd = Notifd.get_default();

  return (
    <window
      className="notifications-window"
      monitor={monitor}
      anchor={Astal.WindowAnchor.TOP}
      marginTop={50}
      exclusivity={Astal.Exclusivity.IGNORE}
    >
      <box vertical className="notifications-list">
        {bind(notifd, 'notifications').as((ns) =>
          ns.map((n) => {
            const isCritical = n.urgency === Notifd.Urgency.CRITICAL;
            const className = `notification ${isCritical ? 'critical' : ''}`;

            return (
              <box
                className={className}
                vertical
                setup={(self) => {
                  const timeout = isCritical ? 10000 : 5000;
                  const id = GLib.timeout_add(
                    GLib.PRIORITY_DEFAULT,
                    timeout,
                    () => {
                      n.dismiss();
                      return GLib.SOURCE_REMOVE;
                    },
                  );
                  self.connect('destroy', () => GLib.source_remove(id));
                }}
              >
                <button className="content-btn" onClick={() => n.dismiss()}>
                  <box vertical>
                    <box className="header">
                      {n.appIcon && <icon icon={n.appIcon} />}
                      <label
                        className="app-name"
                        label={n.appName || 'System'}
                      />
                      <label
                        className="time"
                        hexpand
                        halign={Gtk.Align.END}
                        label={time(n.time)}
                      />
                    </box>
                    <box className="content" spacing={10}>
                      {n.image && <icon className="image" icon={n.image} />}
                      <box vertical>
                        <label
                          className="summary"
                          halign={Gtk.Align.START}
                          label={n.summary}
                          truncate
                        />
                        <label
                          className="body"
                          halign={Gtk.Align.START}
                          label={n.body}
                          wrap
                        />
                      </box>
                    </box>
                  </box>
                </button>

                {n.actions.length > 0 && (
                  <box className="actions" spacing={5}>
                    {n.actions.map(({ id, label }) => (
                      <button hexpand onClick={() => n.invoke(id)}>
                        <label label={label} />
                      </button>
                    ))}
                  </box>
                )}
              </box>
            );
          }),
        )}
      </box>
    </window>
  );
}
