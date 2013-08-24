function math.lerp(x, y, z)
	return x + (y - x) * z
end

function math.distance(x1, y1, x2, y2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ .5
end

function math.direction(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end

function math.hcora(cx, cy, cr, rx, ry, rw, rh) -- Hot circle on rectangle action.
  local hw, hh = rw / 2, rh / 2
  local cdx, cdy = math.abs(cx - (rx + hw)), math.abs(cy - (ry + hh))
  if cdx > hw + cr or cdy > hh + cr then return false end
  if cdx <= hw or cdy <= hh then return true end
  return (cdx - hw) ^ 2 + (cdy - hh) ^ 2 <= (cr ^ 2)
end

function math.hcoca(x1, y1, r1, x2, y2, r2) -- Hot circle on circle action.
  local dx, dy, r = x2 - x1, y2 - y1, r1 + r2
  return (dx * dx) + (dy * dy) < r * r
end