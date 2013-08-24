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
walls[1] = Wall.create(500, 400, 50, 300)
walls[2] = Wall.create(200, 0, 30, 600)
walls[3] = Wall.create(1080, 200, 30, 600)
walls[4] = Wall.create(400, 500, 300, 50)