local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Variable = astal.Variable
local bind = astal.bind
local GLib = astal.require("GLib")
local Wp = astal.require("AstalWp")
local Tray = astal.require("AstalTray")
local utils = require("utils")

local function create_workspace_monitor()
	local active_workspace = Variable(1)
	local occupied_workspaces = Variable({})

	local function update_workspaces()
		local handle_active_workspace = io.popen("swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .num'")
		local handle_occupied_workspaces = io.popen("swaymsg -t get_workspaces | jq '.[].num'")

		if handle_active_workspace and handle_occupied_workspaces then
			local result_active_workspace = handle_active_workspace:read("*a")
			local result_occupied_workspaces = handle_occupied_workspaces:read("*a")

			handle_active_workspace:close()
			handle_occupied_workspaces:close()

			active_workspace:set(tonumber(result_active_workspace))

			local workspaces = {}
			for i in result_occupied_workspaces:gmatch("%d+") do
				table.insert(workspaces, tonumber(i))
			end
			occupied_workspaces:set(workspaces)
		end
	end

	GLib.timeout_add(GLib.PRIORITY_DEFAULT, utils.TIMEOUT, function()
		update_workspaces()
		return true
	end)

	update_workspaces()
	return active_workspace, occupied_workspaces
end

local function VolumeSlider(type)
	local audio = Wp.get_default().audio
	local device = type == "speaker" and audio.default_speaker or audio.default_source

	return Widget.Slider({
		hexpand = true,
		draw_value = false,
		on_value_changed = function(self)
			device.volume = self.value
		end,
		value = bind(device, "volume"),
	})
end

local function VolumeIndicator(type)
	local audio = Wp.get_default().audio
	local device = type == "speaker" and audio.default_speaker or audio.default_source

	if not device then
		return Widget.Box({})
	end

	return Widget.Button({
		Widget.Icon({
			icon = bind(device, "volume-icon"):as(function(_)
				return type == "speaker" and "audio-speakers-symbolic" or "audio-headphones-symbolic"
			end),
		}),
	})
end

local function Volume()
	return Widget.Box({
		class_name = "volume",
		VolumeIndicator("speaker"),
		VolumeSlider("speaker"),
	})
end

local function Workspaces()
	local active_workspace, occupied_workspaces = create_workspace_monitor()

	return Widget.Box({
		class_name = "workspaces",
		bind(active_workspace):as(function(a)
			local children = {}
			for i = 1, 10 do
				table.insert(
					children,
					Widget.Button({
						on_clicked = function()
							utils.execute_sway_command(string.format("workspace number %d", i))
						end,
						label = utils.arr_labels_in_japanese[i],
						class_name = (function()
							if a == i then
								return "focused"
							elseif occupied_workspaces:get()[i] then
								return "occupied"
							end
							return ""
						end)(),
					})
				)
			end
			return children
		end),
	})
end

local function Clock()
	local time = Variable(""):poll(1000, function()
		return GLib.DateTime.new_now_local():format("%a. %b %e - %H:%M:%S")
	end)

	return Widget.Label({
		class_name = "clock",
		on_destroy = function()
			time:drop()
		end,
		label = time(),
	})
end

local function SysTray()
	local tray = Tray.get_default()

	return Widget.Box({
		class_name = "tray",
		bind(tray, "items"):as(function(items)
			return utils.map(items, function(item)
				return Widget.MenuButton({
					tooltip_markup = bind(item, "tooltip_markup"),
					use_popover = false,
					menu_model = bind(item, "menu-model"),
					action_group = bind(item, "action-group"):as(function(ag)
						return { "dbusmenu", ag }
					end),
					Widget.Icon({
						gicon = bind(item, "gicon"),
					}),
				})
			end)
		end),
	})
end

local function ClientTitle()
	local title = Variable("")

	local function update_title()
		local handle = io.popen("swaymsg -t get_tree | jq -r '.. | select(.focused?) | .name'")
		if handle then
			local result = handle:read("*a")
			handle:close()
			local value = result:gsub("^%s*(.-)%s*$", "%1")
			if not tonumber(value) then
				title:set(value)
			else
				title:set("")
			end
		end
	end

	GLib.timeout_add(GLib.PRIORITY_DEFAULT, utils.TIMEOUT, function()
		update_title()
		return true
	end)

	return Widget.Label({
		class_name = "client-title",
		ellipsize = "END",
		max_width_chars = 56,
		label = title(),
	})
end

local function Left()
	return Widget.Box({
		Workspaces(),
	})
end

local function Center()
	return Widget.Box({
		ClientTitle(),
	})
end

local function Right()
	return Widget.Box({
		halign = "END",
		SysTray(),
		Volume(),
		Clock(),
	})
end

return function(monitor)
	local WindowAnchor = astal.require("Astal", "3.0").WindowAnchor

	return Widget.Window({
		name = "bar-" .. monitor,
		class_name = "bar",
		monitor = monitor,
		anchor = WindowAnchor.BOTTOM + WindowAnchor.LEFT + WindowAnchor.RIGHT,
		exclusivity = "EXCLUSIVE",
		Widget.CenterBox({
			class_name = "body",
			start_widget = Left(),
			center_widget = Center(),
			end_widget = Right(),
		}),
	})
end
