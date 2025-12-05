import { App, Astal, Gtk } from 'astal/gtk3';
import { Variable, bind, GLib } from 'astal';
import { execAsync } from 'astal/process';
import Wp from 'gi://AstalWp';
import Tray from 'gi://AstalTray';
import Pango from 'gi://Pango';

const TIMEOUT = 200;
const JAPANESE_LABELS = [
  '一',
  '二',
  '三',
  '四',
  '五',
  '六',
  '七',
  '八',
  '九',
  '十',
];

type WMState = {
  activeWs: Variable<number>;
  occupiedWs: Variable<number[]>;
  title: Variable<string>;
  focusWorkspace: (id: number) => void;
};

const getWM = (): WMState => {
  const current = GLib.getenv('XDG_CURRENT_DESKTOP') || '';

  if (current.toLowerCase().includes('niri')) {
    const activeWs = Variable(1);
    const occupiedWs = Variable<number[]>([]);
    const title = Variable('');

    Variable(null).poll(TIMEOUT, () => {
      execAsync('niri msg workspaces')
        .then((out) => {
          const occupied: number[] = [];
          let active = 1;
          out.split('\n').forEach((line) => {
            const match = line.match(/^\s*(\*?)\s*(\d+)/);
            if (match) {
              const id = parseInt(match[2]);
              occupied.push(id);
              if (match[1] === '*') active = id;
            }
          });
          occupiedWs.set(occupied);
          activeWs.set(active);
        })
        .catch(() => {});
    });

    Variable(null).poll(TIMEOUT, () => {
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

    Variable(null).poll(TIMEOUT, () => {
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

    Variable(null).poll(TIMEOUT, () => {
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

const wm = getWM();

function Workspaces() {
  return (
    <box className="workspaces">
      {JAPANESE_LABELS.map((label, i) => {
        const wsNum = i + 1;

        const className = Variable.derive(
          [wm.activeWs, wm.occupiedWs],
          (active, occupied) => {
            if (active === wsNum) return 'focused';
            if (occupied.includes(wsNum)) return 'occupied';
            return '';
          },
        );

        return (
          <button
            label={label}
            onClicked={() => wm.focusWorkspace(wsNum)}
            className={bind(className)}
          />
        );
      })}
    </box>
  );
}

function ClientTitle() {
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
          <menubutton
            tooltipMarkup={bind(item, 'tooltipMarkup')}
            usePopover={false}
            actionGroup={bind(item, 'actionGroup').as((ag) => ['dbusmenu', ag])}
            menuModel={bind(item, 'menuModel')}
          >
            <icon gicon={bind(item, 'gicon')} />
          </menubutton>
        )),
      )}
    </box>
  );
}

export default function Bar(monitor: number) {
  return (
    <window
      name={`bar-${monitor}`}
      className="bar"
      monitor={monitor}
      anchor={
        Astal.WindowAnchor.BOTTOM |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={App}
    >
      <centerbox
        className="body"
        startWidget={
          <box>
            <Workspaces />
          </box>
        }
        centerWidget={
          <box>
            <ClientTitle />
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
