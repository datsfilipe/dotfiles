local M = {}

M.TIMEOUT = 50

M.arr_labels_in_japanese = {
	"一",
	"二",
	"三",
	"四",
	"五",
	"六",
	"七",
	"八",
	"九",
	"十",
}

function M.map(arr, fn)
	result = {}
	for i, v in ipairs(arr) do
		table.insert(result, fn(v, i))
	end
	return result
end

function M.get_sway_socket()
	return os.getenv("SWAYSOCK")
end

function M.execute_sway_command(cmd)
	local socket = M.get_sway_socket()
	if socket then
		os.execute(string.format("swaymsg -s %s '%s'", socket, cmd))
	end
end

function M.get_src(path)
	local str = debug.getinfo(2, "S").source:sub(2)
	local src = str:match("(.*/)") or str:match("(.*\\)") or "./"
	return src .. path
end

function M.file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

return M
