return {
  {
    'echasnovski/mini.hipatterns',
    main = 'mini.hipatterns',
    event = { 'BufReadPost' },
    opts = function()
      local utils = require 'utils'

      local function create_color_highlighter(pattern, extract_fn)
        return {
          pattern = pattern,
          group = function(_, match)
            local hex_color = extract_fn(match)
            if hex_color:len() > 7 then
              hex_color = hex_color:sub(1, 7)
            end
            return hipatterns.compute_hex_color_group(hex_color, 'bg')
          end,
        }
      end

      local function extract_hsl(match)
        local h, s, l = match:match 'hsl%((%d+),? (%d+),? (%d+)%)'
        return utils.hslToHex(tonumber(h), tonumber(s), tonumber(l))
      end

      local function extract_rgb(match)
        local r, g, b = match:match 'rgb%((%d+),? (%d+),? (%d+)%)'
        return string.format(
          '#%02x%02x%02x',
          tonumber(r),
          tonumber(g),
          tonumber(b)
        )
      end

      local function extract_rgba(match)
        local r, g, b = match:match 'rgba%((%d+),? (%d+),? (%d+),? [%d%.]+%)'
        return string.format(
          '#%02x%02x%02x',
          tonumber(r),
          tonumber(g),
          tonumber(b)
        )
      end

      local highlighters = {}
      for _, word in ipairs { 'todo', 'note', 'hack', 'fixme' } do
        highlighters[word] = {
          pattern = string.format('%%f[%%w]()%s()%%f[%%W]', word:upper()),
          group = string.format(
            'MiniHipatterns%s',
            word:sub(1, 1):upper() .. word:sub(2)
          ),
        }
      end

      highlighters['hsl'] =
        create_color_highlighter('hsl%(%d+,? %d+,? %d+%)', extract_hsl)

      highlighters['rgb'] =
        create_color_highlighter('rgb%(%d+,? %d+,? %d+%)', extract_rgb)

      highlighters['rgba'] = create_color_highlighter(
        'rgba%(%d+,? %d+,? %d+,? [%d%.]+%)',
        extract_rgba
      )

      return { highlighters = highlighters }
    end,
  },
}
