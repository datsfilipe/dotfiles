-- autosave.lua script

-- Fork from: https://gist.github.com/CyberShadow/2f71a97fb85ed42146f6d9f522bc34ef
local options = require 'mp.options'

local o = {
  save_period = 60
}

options.read_options(o)

local mp = require 'mp'

local function save()
  local filename = mp.get_property("filename")

  -- Just save if there is a filename and it doesn't finish with .mp3
  if filename and not filename:match(".mp3$") then
    mp.commandv("set", "msg-level", "cplayer=warn")
    mp.command("write-watch-later-config")
    mp.commandv("set", "msg-level", "cplayer=status")
  end
end

local save_period_timer = mp.add_periodic_timer(o.save_period, save)

local function pause(name, paused)
  save()
  if paused then
    save_period_timer:stop()
  else
    save_period_timer:resume()
  end
end

mp.observe_property("pause", "bool", pause)
mp.register_event("file-loaded", save)

local function end_file(data)
  if data.reason == 'eof' or data.reason == 'stop' then
    local playlist = mp.get_property_native('playlist')
    for i, entry in pairs(playlist) do
      if entry.id == data.playlist_entry_id then
        mp.commandv("delete-watch-later-config", entry.filename)
        return
      end
    end
  end
end

mp.register_event("end-file", end_file)
