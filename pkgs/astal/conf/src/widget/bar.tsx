import { labelMap, updateInterval } from '../lib/constants';
import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable, bind, GLib } from 'astal';
import { execAsync } from 'astal/process';
import Wp from 'gi://AstalWp';
import Tray from 'gi://AstalTray';
import Pango from 'gi://Pango';

type WMState = {
  activeWs: Variable<number>;
  occupiedWs: Variable<number[]>;
  title: Variable<string>;
  focusWorkspace: (id: number) => void;
};

const getWM = (monitor: number): WMState => {
  const current = GLib.getenv('XDG_CURRENT_DESKTOP') || '';

  if (current.toLowerCase().includes('niri')) {
    const activeWs = Variable(1);
    const occupiedWs = Variable<number[]>([]);
    const title = Variable('');

    Variable(null).poll(updateInterval, () => {
      execAsync('niri msg workspaces')
        .then((out) => {
          const monitors = out.split(/^Output /m).slice(1);
          const currentMonitorData = monitors[monitor];

          if (!currentMonitorData) return;

          const occupied = new Set<number>();
          let active = 1;

          currentMonitorData.split('\n').forEach((line) => {
            const match = line.match(/^\s*(\*?)\s*(\d+)/);
            if (match) {
              const id = parseInt(match[2]);
              occupied.add(id);
              if (match[1] === '*') active = id;
            }
          });

          occupiedWs.set([...occupied].sort((a, b) => a - b));
          activeWs.set(active);
        })
        .catch(() => {});
    });

    Variable(null).poll(updateInterval, () => {
      execAsync('niri msg focused-window')
        .then((out) => {
          const match = out.match(/Title: "(.*)"/);
          if (match) title.set(match[1]);
          else title.set('');
        })
        .catch(() => title.set(''));
    });

    return {
      activeWs,
      occupiedWs,
      title,
      focusWorkspace: (id) =>
        execAsync(`niri msg action focus-workspace ${id}`),
    };
  } else {
    const activeWs = Variable(1);
    const occupiedWs = Variable<number[]>([]);
    const title = Variable('');

    Variable(null).poll(updateInterval, () => {
      execAsync('swaymsg -t get_workspaces')
        .then((out) => {
          try {
            const data = JSON.parse(out);
            const active = data.find((w: any) => w.focused)?.num || 1;
            const occupied = data.map((w: any) => w.num);
            activeWs.set(active);
            occupiedWs.set(occupied);
          } catch (e) {}
        })
        .catch(() => {});
    });

    Variable(null).poll(updateInterval, () => {
      execAsync('swaymsg -t get_tree')
        .then((out) => {
          try {
            const tree = JSON.parse(out);
            const findFocused = (node: any): string | null => {
              if (node.focused) return node.name;
              for (const child of node.nodes || []) {
                const res = findFocused(child);
                if (res) return res;
              }
              for (const child of node.floating_nodes || []) {
                const res = findFocused(child);
                if (res) return res;
              }
              return null;
            };
            let raw = findFocused(tree) || '';
            if (!isNaN(Number(raw)) && raw.trim() !== '') title.set('');
            else title.set(raw);
          } catch (e) {}
        })
        .catch(() => {});
    });

    return {
      activeWs,
      occupiedWs,
      title,
      focusWorkspace: (id) => execAsync(`swaymsg workspace number ${id}`),
    };
  }
};

function Workspaces({ wm }: { wm: WMState }) {
  return (
    <box className="workspaces">
      {bind(wm.occupiedWs).as((ids) =>
        ids.map((id) => {
          const label = labelMap[id - 1] || String(id);
          return (
            <button
              label={label}
              onClick={() => wm.focusWorkspace(id)}
              className={bind(wm.activeWs).as((active) =>
                active === id ? 'focused' : ''
              )}
            />
          );
        })
      )}
    </box>
  );
}

function ClientTitle({ wm }: { wm: WMState }) {
  return (
    <label
      className="client-title"
      ellipsize={Pango.EllipsizeMode.END}
      maxWidthChars={56}
      label={bind(wm.title)}
    />
  );
}

function Volume() {
  const audio = Wp.get_default()?.audio;
  const speaker = audio?.defaultSpeaker;

  if (!speaker) return <box />;

  return (
    <box className="volume">
      <button>
        <icon
          icon={bind(speaker, 'volumeIcon').as(() => 'audio-speakers-symbolic')}
        />
      </button>
      <slider
        hexpand
        drawValue={false}
        value={bind(speaker, 'volume')}
        onDragged={({ value }) => (speaker.volume = value)}
      />
    </box>
  );
}

function Clock() {
  const time = Variable('').poll(
    1000,
    () => GLib.DateTime.new_now_local().format('%a. %b %e - %H:%M:%S')!,
  );
  return (
    <label className="clock" label={bind(time)} onDestroy={() => time.drop()} />
  );
}

function SysTray() {
  const tray = Tray.get_default();
  return (
    <box className="tray">
      {bind(tray, 'items').as((items) =>
        items.map((item) => (
          <button
            tooltipMarkup={bind(item, 'tooltipMarkup')}
            onClick={(self, event) => {
              if (event.button === Astal.MouseButton.PRIMARY) {
                item.activate(0, 0);
              } else if (event.button === Astal.MouseButton.SECONDARY) {
                const menu = Gtk.Menu.new_from_model(item.menuModel);
                menu.insert_action_group('dbusmenu', item.actionGroup);
                // Added class for styling
                menu.get_style_context().add_class('tray-menu');
                menu.popup_at_widget(
                  self,
                  Gdk.Gravity.SOUTH,
                  Gdk.Gravity.NORTH,
                  null,
                );
              }
            }}
          >
            <icon gicon={bind(item, 'gicon')} />
          </button>
        )),
      )}
    </box>
  );
}

export default function Bar(monitor: number) {
  const wm = getWM(monitor);
  return (
    <window
      name={`bar-${monitor}`}
      className="bar"
      monitor={monitor}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={App}
      marginTop={8}
      marginLeft={8}
      marginRight={8}
    >
      <centerbox
        className="body"
        startWidget={
          <box>
            <Workspaces wm={wm} />
          </box>
        }
        centerWidget={
          <box>
            <ClientTitle wm={wm} />
          </box>
        }
        endWidget={
          <box halign={Gtk.Align.END}>
            <SysTray />
            <Volume />
            <Clock />
          </box>
        }
      />
    </window>
  );
}
