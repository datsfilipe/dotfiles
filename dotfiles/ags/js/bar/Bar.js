import {
  Hyprland,
  Audio,
  SystemTray,
  App,
  Widget,
  Utils,
} from '../imports.js';

const VolumeIndicator = (type = 'speaker') => Widget.Button({
  onClicked: () => Audio[type].is_muted = !Audio[type].is_muted,
  child: Widget.Icon({
    connections: [[Audio, icon => {
      if (!Audio[type])
        return;

      icon.icon = type === 'speaker'
        ? 'audio-speakers-symbolic'
        : 'audio-headphones-symbolic';

      icon.tooltip_text = `Volume ${Math.floor(Audio[type].volume * 100)}%`;
    }, `${type}-changed`]],
  }),
});

const VolumeSlider = (type = 'speaker') => Widget.Slider({
  hexpand: true,
  drawValue: false,
  onChange: ({ value }) => Audio[type].volume = value,
  connections: [[Audio, slider => {
    slider.value = Audio[type]?.volume;
  }, `${type}-changed`]],
});

const Volume = () => Widget.Box({
  className: 'volume',
  children: [
    VolumeIndicator('speaker'),
    VolumeSlider('speaker'),
  ],
});

const Microphone = () => Widget.Box({
  className: 'microphone',
  binds: [['visible', Audio, 'recorders', r => r.length > 0]],
  children: [
    VolumeIndicator('microphone'),
    VolumeSlider('microphone'),
  ],
});

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
    Microphone(),
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
