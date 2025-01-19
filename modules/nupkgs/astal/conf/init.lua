local astal = require("astal")
local App = require("astal.gtk3.app")
local Bar = require("widget.Bar")
local utils = require("utils")

local scss = "/tmp/modified_styles.scss"
local css = "/tmp/style.css"

local styles = utils.get_src("styles.scss")
local replacement_file = os.getenv("HOME") .. "/.local/share/astal/variables.scss"

local input = io.open(styles, "r")
local output = io.open(scss, "w")

if utils.file_exists(replacement_file) then
	local replacement = io.open(replacement_file, "r")
	if not replacement or not output then
		error("Could not open " .. replacement_file .. " or " .. scss)
	end

	local replacement_content = replacement:read("*a")
	replacement:close()
	output:write(replacement_content)

	local line_count = 0
	if not input then
		error("Could not open " .. styles)
	end

	for line in input:lines() do
		line_count = line_count + 1
		if line_count > 12 then
			output:write(line .. "\n")
		end
	end
else
	if not output or not input then
		error("Could not open " .. scss .. " or " .. styles)
	end

	for line in input:lines() do
		output:write(line .. "\n")
	end
end

input:close()
output:close()

astal.exec("sass " .. scss .. " " .. css)

App:start({
	instance_name = "lua",
	css = css,
	main = function()
		Bar(1)
	end,
})
