local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Variable = astal.Variable
local bind = astal.bind
local GLib = astal.require("GLib")
local Wp = astal.require("AstalWp")
local Tray = astal.require("AstalTray")
local Battery = require("lgi").require("AstalBattery")
local utils = require("utils")

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

local function BatteryIndicator()
	local battery = Battery.get_default()
	
	if not battery then
		return Widget.Box({})
	end

	return Widget.Box({
		class_name = "battery",
		Widget.Icon({
			icon = bind(battery, "battery-icon-name"),
		}),
		Widget.Label({
      class_name = "battery-percentage",
			label = bind(battery, "percentage"):as(function(percentage)
				return string.format("%d%%", math.floor(percentage * 100 + 0.5))
			end),
		}),
	})
end

local function Workspaces()
	local outputs_data = Variable({})

	local function update_workspaces()
		local handle = io.popen("niri msg workspaces")
		if handle then
			local result = handle:read("*a")
			handle:close()
			
			local parsed_outputs = {}
			local output_order = {}
			local current_output = nil
			
			for line in result:gmatch("[^\r\n]+") do
				local output_match = line:match('Output "([^"]+)":')
				if output_match then
					current_output = output_match
					if not parsed_outputs[current_output] then
						table.insert(output_order, current_output)
						parsed_outputs[current_output] = { workspaces = {}, active = nil }
					end
				elseif current_output then
					local is_active = line:match("^%s*%*")
					local ws_num = line:match("%d+")
					
					if ws_num then
						ws_num = tonumber(ws_num)
						table.insert(parsed_outputs[current_output].workspaces, ws_num)
						
						if is_active then
							parsed_outputs[current_output].active = ws_num
						end
					end
				end
			end
			
			outputs_data:set({data = parsed_outputs, order = output_order})
		end
	end
	
	GLib.timeout_add(GLib.PRIORITY_DEFAULT, utils.TIMEOUT, function()
		update_workspaces()
		return true
	end)
	
	update_workspaces()

	return Widget.Box({
		class_name = "all-workspaces",
		spacing = 15,
		bind(outputs_data):as(function(outputs)
			local widgets = {}
			
			for _, output_name in ipairs(outputs.order) do
				local output_data = outputs.data[output_name]
				local output_widget = Widget.Box({
					class_name = "output-workspaces",
					spacing = 5,
					Widget.Label({
						label = outputs.order[1] == output_name and
              "メイン" --[[meine]] or "サブ" --[[sabu]],
						class_name = "output-label"
					}),
					Widget.Box({
						class_name = "workspaces",
						spacing = 2,
						utils.map(output_data.workspaces, function(ws)
							return Widget.Button({
								-- on_clicked = function()
								-- 	utils.execute_niri_command(string.format("action focus-workspace %d", ws))
								-- end,
								label = " ",
								class_name = output_data.active == ws and "focused" or "occupied",
							})
						end)
					})
				})
				
				table.insert(widgets, output_widget)
			end
			
			return widgets
		end)
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
		local handle = io.popen("niri msg focused-window | grep -oP 'Title: \"\\K[^\"]+' 2>/dev/null || echo ''")
		if handle then
			local result = handle:read("*a")
			handle:close()
			local value = result:gsub("^%s*(.-)%s*$", "%1")
			if value ~= "" then
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
		BatteryIndicator(),
		Clock(),
	})
end

return function(monitor)
	local WindowAnchor = astal.require("Astal", "3.0").WindowAnchor

	return Widget.Window({
		name = "bar-" .. monitor,
		class_name = "bar",
		monitor = monitor,
		anchor = WindowAnchor.TOP + WindowAnchor.LEFT + WindowAnchor.RIGHT,
		exclusivity = "EXCLUSIVE",
		Widget.CenterBox({
			class_name = "body",
			start_widget = Left(),
			center_widget = Center(),
			end_widget = Right(),
		}),
	})
end
