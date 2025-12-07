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

            const actions = n.actions.filter(
              (a) =>
                a.id !== 'default' &&
                a.label?.trim() &&
                !a.label.includes(']'),
            );

            return (
              <box
                key={n.id}
                className={className}
                vertical
                setup={(self) => {
                  const now = Date.now();
                  const duration = isCritical ? 10000 : 5000;
                  const creationTime = n.time * 1000;
                  const elapsed = creationTime ? now - creationTime : 0;
                  const remaining = Math.max(0, duration - elapsed);

                  const id = GLib.timeout_add(
                    GLib.PRIORITY_DEFAULT,
                    remaining,
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
                      {n.appIcon && (
                        <icon className="app-icon" icon={n.appIcon} />
                      )}
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
                      <box vertical spacing={4}>
                        <label
                          className="summary"
                          halign={Gtk.Align.CENTER}
                          xalign={0}
                          label={n.summary}
                          tooltipMarkup={n.summary}
                          maxWidthChars={35}
                          lines={2}
                          truncate
                          wrap
                        />
                        {n.body && (
                          <label
                            className="body"
                            halign={Gtk.Align.START}
                            xalign={0}
                            label={n.body}
                            maxWidthChars={35}
                            lines={3}
                            useMarkup
                            tooltipMarkup={n.body}
                            wrap
                            truncate
                          />
                        )}
                      </box>
                    </box>
                  </box>
                </button>

                {actions.length > 0 && (
                  <box className="actions" spacing={5}>
                    {actions.map(({ id, label }) => (
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
