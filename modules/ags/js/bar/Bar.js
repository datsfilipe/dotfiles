import {
  Hyprland,
  Audio,
  SystemTray,
  App,
  Widget,
  Utils,
} from '../imports.js';

const Workspaces = () => Widget.Box({
  className: 'workspaces',
  connections: [[Hyprland.active.workspace, self => {
    const arr = Array.from({ length: 10 }, (_, i) => i + 1);
    self.children = arr.map(i => Widget.Button({
      onClicked: () => Utils.execAsync(`hyprctl dispatch workspace ${i}`),
      child: Widget.Label(`${i}`),
      className: Hyprland.active.workspace.id == i
  ? 'focused'
  : Hyprland.getWorkspace(i)?.windows > 0
  ? 'occupied'
  : ''
    }));
  }]],
});

const ClientTitle = () => Widget.Label({
  className: 'client-title',
  binds: [
    ['label', Hyprland.active.client, 'title'],
  ],
});

const Clock = () => Widget.Label({
  className: 'clock',
  connections: [
    [1000, self => Utils.execAsync(['date', '+%b %e. - %H:%M:%S'])
      .then(date => self.label = date).catch(console.error)],
  ],
});

const Volume = () => Widget.Box({
  className: 'volume',
  style: 'min-width: 180px',
  children: [
    Widget.Stack({
      items: [
        ['101', Widget.Icon('audio-volume-overamplified-symbolic')],
        ['67', Widget.Icon('audio-volume-high-symbolic')],
        ['34', Widget.Icon('audio-volume-medium-symbolic')],
        ['1', Widget.Icon('audio-volume-low-symbolic')],
        ['0', Widget.Icon('audio-volume-muted-symbolic')],
      ],
      connections: [[Audio, self => {
        if (!Audio.speaker)
          return;

        if (Audio.speaker.isMuted) {
          self.shown = '0';
          return;
        }

        const show = [101, 67, 34, 1, 0].find(
          threshold => threshold <= Audio.speaker.volume * 100);

        self.shown = `${show}`;
      }, 'speaker-changed']],
    }),
    Widget.Slider({
      hexpand: true,
      drawValue: false,
      onChange: ({ value }) => Audio.speaker.volume = value,
      connections: [[Audio, self => {
        self.value = Audio.speaker?.volume || 0;
      }, 'speaker-changed']],
    }),
  ],
});

const SysTray = () => Widget.Box({
  className: 'tray',
  connections: [[SystemTray, self => {
    self.children = SystemTray.items.map(item => Widget.Button({
      child: Widget.Icon({ binds: [['icon', item, 'icon']] }),
      onPrimaryClick: (_, event) => item.activate(event),
      onSecondaryClick: (_, event) => item.openMenu(event),
      binds: [['tooltip-markup', item, 'tooltip-markup']],
    }));
  }]],
});

const Left = () => Widget.Box({
  children: [
    Workspaces(),
  ],
});

const Center = () => Widget.Box({
  children: [
    ClientTitle(),
  ],
});

const Right = () => Widget.Box({
  halign: 'end',
  children: [
    SysTray(),
    Volume(),
    Clock(),
  ],
});

const Bar = ({ monitor } = {}) => Widget.Window({
  name: `bar-${monitor}`,
  className: 'bar',
  monitor,
  anchor: ['top', 'left', 'right'],
  exclusive: true,
  child: Widget.CenterBox({
    startWidget: Left(),
    centerWidget: Center(),
    endWidget: Right(),
  }),
});

export default Bar;
