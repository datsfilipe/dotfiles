import { App, Astal, Gtk } from 'astal/gtk3';
import { Variable, bind, GLib } from 'astal';
import { execAsync } from 'astal/process';
import Wp from 'gi://AstalWp';
import { brightnessTick } from '../lib/state';

const OSD_TIMEOUT = 1500;
const BAR_WIDTH = 150;
const MAX_VOLUME = 1.53;

function volumeGlyph(volume: number, mute: boolean) {
  if (mute || volume <= 0) return '󰝟';
  if (volume < 0.34) return '󰕿';
  if (volume < 0.67) return '󰖀';
  return '󰕾';
}

export default function Osd(monitor: number) {
  const visible = Variable(false);
  const glyph = Variable('󰕾');
  const normalWidth = Variable(0);
  const dangerWidth = Variable(0);
  const over = Variable(false);

  let hideTimer = 0;
  const reveal = () => {
    visible.set(true);
    if (hideTimer) GLib.source_remove(hideTimer);
    hideTimer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, OSD_TIMEOUT, () => {
      visible.set(false);
      hideTimer = 0;
      return GLib.SOURCE_REMOVE;
    });
  };

  let armed = false;
  GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
    armed = true;
    return GLib.SOURCE_REMOVE;
  });

  const speaker = Wp.get_default()?.audio?.defaultSpeaker;
  if (speaker) {
    const update = () => {
      const v = Math.min(MAX_VOLUME, speaker.mute ? 0 : speaker.volume);
      glyph.set(volumeGlyph(speaker.volume, speaker.mute));
      normalWidth.set(Math.round((Math.min(v, 1) / MAX_VOLUME) * BAR_WIDTH));
      dangerWidth.set(Math.round((Math.max(0, v - 1) / MAX_VOLUME) * BAR_WIDTH));
      over.set(v > 1);
      if (armed) reveal();
    };
    speaker.connect('notify::volume', update);
    speaker.connect('notify::mute', update);
  }

  brightnessTick.subscribe(() => {
    execAsync('brightnessctl -m -c backlight')
      .then((out) => {
        const pct = parseInt(out.trim().split(',')[3]);
        if (isNaN(pct)) return;
        glyph.set('󰃠');
        normalWidth.set(Math.round((Math.min(1, pct / 100)) * BAR_WIDTH));
        dangerWidth.set(0);
        over.set(false);
        reveal();
      })
      .catch(() => {});
  });

  return (
    <window
      name={`osd-${monitor}`}
      namespace="osd"
      className="osd-window"
      monitor={monitor}
      anchor={Astal.WindowAnchor.BOTTOM}
      marginBottom={140}
      exclusivity={Astal.Exclusivity.IGNORE}
      visible={bind(visible)}
      application={App}
    >
      <box
        className="osd"
        vertical
        spacing={18}
        halign={Gtk.Align.CENTER}
        valign={Gtk.Align.CENTER}
      >
        <label
          className={bind(over).as((o) =>
            o ? 'osd-icon danger' : 'osd-icon',
          )}
          label={bind(glyph)}
        />
        <box
          className="osd-track"
          widthRequest={BAR_WIDTH}
          heightRequest={6}
          valign={Gtk.Align.CENTER}
        >
          <box
            className={bind(dangerWidth).as((d) =>
              d > 0 ? 'osd-fill capped' : 'osd-fill',
            )}
            heightRequest={6}
            widthRequest={bind(normalWidth)}
          />
          <box
            className="osd-fill-danger"
            heightRequest={6}
            visible={bind(dangerWidth).as((d) => d > 0)}
            widthRequest={bind(dangerWidth)}
          />
        </box>
      </box>
    </window>
  );
}
