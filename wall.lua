Wall = {}

function Wall.create(x, y, w, h)
	local wall = {
		x = x,
		y = y,
		w = w,
		h = h
	}

	setmetatable(wall, {__index = Wall})

	return wall
end

function Wall:draw()
	love.graphics.setColor(128, 128, 128)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

walls = {}