import { Widget, Service, lookUpIcon } from '../imports.js'

const notifications = await Service.import('notifications')

function NotificationIcon({ app_entry, app_icon, image }) {
  if (image) {
    return Widget.Box({
      css: `background-image: url("${image}");`
        + 'background-size: contain;'
        + 'background-repeat: no-repeat;'
        + 'background-position: center;',
    })
  }

  let icon = ''
  if (lookUpIcon(app_icon))
    icon = app_icon

  if (app_entry && lookUpIcon(app_entry))
    icon = app_entry

  if (icon)
    return Widget.Icon(icon)
  else
    return Widget.Box({})
}

function Notification(n) {
  const icon = Widget.Box({
    vpack: 'start',
    className: n.image || lookUpIcon(n.app_icon) ? 'icon' : '',
    child: NotificationIcon(n),
  })

  const title = Widget.Label({
    className: 'title',
    xalign: 0,
    justification: 'left',
    hexpand: true,
    maxWidthChars: 24,
    truncate: 'end',
    wrap: true,
    label: n.summary,
    useMarkup: true,
  })

  const body = Widget.Label({
    className: 'body',
    hexpand: true,
    useMarkup: true,
    xalign: 0,
    justification: 'left',
    label: n.body,
    wrap: true,
  })

  const actions = Widget.Box({
    className: 'actions',
    children: n.actions.map(({ id, label }) => Widget.Button({
      className: 'action-button',
      onClicked: () => {
        n.invoke(id)
        n.dismiss()
      },
      hexpand: true,
      child: Widget.Label(label),
    })),
  })

  return Widget.EventBox(
    {
      attribute: { id: n.id },
      onPrimaryClick: n.dismiss,
    },
    Widget.Box(
      {
        className: `notification ${n.urgency}`,
        vertical: true,
      },
      Widget.Box([
        icon,
        Widget.Box(
          { vertical: true },
          title,
          body,
        ),
      ]),
      actions,
    ),
  )
}

export default function NotificationPopups(monitor = 0) {
  const list = Widget.Box({
    vertical: true,
    children: notifications.popups.map(Notification),
  })

  function onNotified(_, id) {
    const n = notifications.getNotification(id)
    if (n)
      list.children = [...list.children, Notification(n)]
  }

  function onDismissed(_, id) {
    list.children.find(n => n.attribute.id === id)?.destroy()
  }

  list.hook(notifications, onNotified, 'notified')
    .hook(notifications, onDismissed, 'dismissed')

  return Widget.Window({
    monitor,
    name: `notifications${monitor}`,
    className: 'notification-popups',
    anchor: ['top', 'right'],
    child: Widget.Box({
      css: 'min-width: 2px; min-height: 2px;',
      className: 'notifications',
      vertical: true,
      child: list,
    }),
  })
}
