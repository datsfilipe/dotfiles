local M = {}

M.TIMEOUT = 200

function M.map(arr, fn)
	result = {}
	for i, v in ipairs(arr) do
		table.insert(result, fn(v, i))
	end
	return result
end

function M.execute_niri_command(cmd)
	os.execute(string.format("niri msg %s", cmd))
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

function M.contains_value(tbl, value)
	for _, v in ipairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

return M
