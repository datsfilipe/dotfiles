import PopupWindow from "../misc/PopupWindow.js";
import { Widget, Applications, App, Hyprland, lookUpIcon } from "../imports.js";
import { Fzf } from "../../node_modules/fzf/dist/fzf.es.js";

const AppIcon = (app) => {
  const icon = lookUpIcon(app.icon_name) ? app.icon_name : "image-missing";
  return Widget.Icon({
    className: "app-icon",
    icon: icon,
  });
};

const AppButton = (app) =>
  Widget.Button({
    onClicked: () => {
      app.launch();
      Hyprland.sendMessage(`dispatch exec ${app.executable}`)
        .then((e) => print(e))
        .catch(logError);
      app._frequency++;
      App.closeWindow("launcher");
    },
    setup: (button) => {
      button.app = app;
      button.connect("destroy", () => print("BUTTON DESTROY", app.name));
    },
    tooltipText: app.description,
    className: "app-button",
    child: Widget.Box({
      children: [
        AppIcon(app),
        Widget.Box({
          vertical: true,
          children: [
            Widget.Label({
              xalign: 0,
              max_width_chars: 28,
              truncate: "end",
              use_markup: true,
              label: app.name,
              className: "app-name",
            }),
            Widget.Label({
              xalign: 0,
              max_width_chars: 40,
              truncate: "end",
              label: app.description
                ? app.description
                : "01101110 01101111 01101110 01100101",
              className: "app-description",
            }),
          ],
        }),
      ],
    }),
    connections: [
      [
        "focus-in-event",
        (self) => {
          self.toggleClassName("focused", true);
        },
      ],
      [
        "focus-out-event",
        (self) => {
          self.toggleClassName("focused", false);
        },
      ],
    ],
  });

const SearchBox = () => {
  const fzf = new Fzf(Applications.list.map(AppButton), {
    selector: (item) => item.app.name,
    tiebreakers: [(a, b, _) => b.item.app._frequency - a.item.app._frequency],
  });
  const results = Widget.Box({
    vertical: true,
    vexpand: true,
    className: "search-results",
  });
  const entry = Widget.Entry({
    className: "search-entry",
    connections: [
      [
        "notify::text",
        (entry) => {
          const text = entry.text;
          results.children.forEach((c) => results.remove(c));
          const fzfResults = fzf.find(text);
          fzfResults.forEach((entry) => {
            const nameChars = entry.item.app.name.normalize().split("");
            const nameMarkup = nameChars
              .map((char, i) => {
                if (entry.positions.has(i))
                  return `<span foreground="red">${char}</span>`;
                else return char;
              })
              .join("");
            entry.item.child.children[1].children[0].label = nameMarkup;
          });
          results.children = fzfResults.map((e) => e.item);
        },
      ],
      [
        App,
        (_, name, visible) => {
          if (name !== "launcher" || !visible) return;
          entry.text = "";
          entry.grab_focus();
        },
        "window-toggled",
      ],
    ],
  });
  return Widget.Box({
    vertical: true,
    className: "launcher",
    children: [
      entry,
      Widget.Scrollable({
        className: "search-scroll",
        child: results,
      }),
    ],
  });
};

export default () =>
  PopupWindow({
    name: "launcher",
    content: SearchBox(),
  });
