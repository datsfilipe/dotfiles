import { App, Widget } from '../imports.js'

const PopupRevealer = (windowName, transition, child) =>
  Widget.Box({
    css: 'padding: 1px;',
    child: Widget.Revealer({
      transition,
      child,
      transitionDuration: 250,
      setup: self => self.hook(App, (revealer, name, visible) => {
        if (windowName !== name) return
        revealer.reveal_child = visible
      }),
    })
  })

const layouts = {
  center: (_, child, expand) =>
    Widget.CenterBox({
      className: 'shader' + expand ? ' popup-bg black' : '',
      centerWidget: Widget.CenterBox({
        vertical: true,
        centerWidget: child,
      }),
    }),
  top: (windowName, child) =>
    Widget.CenterBox({
      centerWidget: Widget.Box({
        vertical: true,
        children: [
          PopupRevealer(windowName, 'slide_down', child),
        ],
      }),
    }),
}

export default ({ layout = 'center', expand = true, name, content, ...rest }) =>
  Widget.Window({
    name,
    child: layouts[layout](name, content, expand),
    visible: false,
    keymode: 'on-demand',
    ...rest,
  }).keybind('Escape', () => App.closeWindow(name))
