---@diagnostic disable: undefined-global
local utils = require("mp.utils")

local cover_filenames = {
	"cover.png",
	"cover.jpg",
	"cover.jpeg",
	"folder.jpg",
	"folder.png",
	"folder.jpeg",
	"AlbumArtwork.png",
	"AlbumArtwork.jpg",
	"AlbumArtwork.jpeg",
}

local function notify(summary, body, options)
	local option_args = {}
	for key, value in pairs(options or {}) do
		table.insert(option_args, string.format("--%s=%s", key, value))
	end
	return mp.command_native({
		"run",
		"notify-send",
		---@diagnostic disable-next-line: deprecated
		unpack(option_args),
		summary,
		body,
	})
end

local function escape_pango_markup(str)
	return string.gsub(str, "([\"'<>&])", function(char)
		return string.format("&#%d;", string.byte(char))
	end)
end

local function notify_media(title, origin, thumbnail)
	return notify(escape_pango_markup(title), origin, {
		-- For some inscrutable reason, GNOME 3.24.2
		-- nondeterministically fails to pick up the notification icon
		-- if either of these two parameters are present.
		--
		-- urgency = "low",
		-- ["app-name"] = "mpv",

		-- ...and this one makes notifications nondeterministically
		-- fail to appear altogether.
		--
		-- hint = "string:desktop-entry:mpv",

		icon = thumbnail or "mpv",
	})
end

local function file_exists(path)
	local info, _ = utils.file_info(path)
	return info ~= nil
end

local function find_cover(dir)
	-- make dir an absolute path
	if dir[1] ~= "/" then
		dir = utils.join_path(utils.getcwd(), dir)
	end

	for _, file in ipairs(cover_filenames) do
		local path = utils.join_path(dir, file)
		if file_exists(path) then
			return path
		end
	end

	return nil
end

function notify_current_media()
	local path = mp.get_property_native("path")

	local dir, file = utils.split_path(path)

	-- TODO: handle embedded covers and videos?
	-- potential options: mpv's take_screenshot, ffprobe/ffmpeg, ...
	-- hooking off existing desktop thumbnails would be good too
	local thumbnail = find_cover(dir)

	local title = file
	local origin = dir

	local metadata = mp.get_property_native("metadata")
	if metadata then
		local function tag(name)
			return metadata[string.upper(name)] or metadata[name]
		end

		title = tag("title") or title
		origin = tag("artist_credit") or tag("artist") or ""

		local album = tag("album")
		if album then
			origin = string.format("%s — %s", origin, album)
		end

		local year = tag("original_year") or tag("year")
		if year then
			origin = string.format("%s (%s)", origin, year)
		end
	end

	return notify_media(title, origin, thumbnail)
end

mp.register_event("file-loaded", notify_current_media)
