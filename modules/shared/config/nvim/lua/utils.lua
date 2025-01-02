local M = {}

M.static_color = '#343434'

M.is_bin_available = function(bin)
  local path = vim.fn.executable(bin)
  return path == 1
end

function M.hsl2rgb(h, s, l)
  if s == 0 then
    return l, l, l
  end

  local function hr(p, q, t)
    t = (t < 0 and t + 1) or (t > 1 and t - 1) or t
    if t < 1 / 6 then
      return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
      return q
    end
    if t < 2 / 3 then
      return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
  end

  local q = l < 0.5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  return hr(p, q, h + 1 / 3) * 255, hr(p, q, h) * 255, hr(p, q, h - 1 / 3) * 255
end

function M.hsl2hex(h, s, l)
  return string.format('#%02x%02x%02x', M.hsl2rgb(h / 360, s / 100, l / 100))
end

M.rgb2hex = function(r, g, b)
  return string.format('#%02x%02x%02x', r, g, b)
end

return M
