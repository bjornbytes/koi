function math.lerp(x, y, z)
	return x + (y - x) * z
end

function math.anglerp(d1, d2, z) return d1 + (math.anglediff(d1, d2) * z) end
function math.anglediff(d1, d2) return math.rad((((math.deg(d2) - math.deg(d1) % 360) + 540) % 360) - 180) end

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

function math.inside(px, py, rx, ry, rw, rh) return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

function table.print(t, n)
  n = n or 0
  if t == nil then print('nil') end
  if type(t) ~= 'table' then io.write(tostring(t)) io.write('\n')
  else
    for k, v in pairs(t) do
      io.write(string.rep('\t', n))
      io.write(k)
      if type(v) == 'table' then io.write('\n')
      else io.write('\t') end
      table.print(v, n + 1)
    end
  end
end

function table.count(t)
  local ct = 0
  for k, v in pairs(t) do
    ct = ct + 1
  end
  return ct
end