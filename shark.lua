Shark = {}

sharks = {}

function Shark.create()
	local shark = {
		id = #sharks + 1,
		x = 0,
		y = 0,
		angle = 0,
		speed = 400,
		sprite = sprShark
	}

	setmetatable(shark, {__index = Shark})

	sharks[#sharks + 1] = shark

	if math.random() < .5 then
		shark.x = -200
		shark.y = 100 + (math.random() * (love.graphics.getHeight() - 100))
		shark.angle = math.pi * 2
		shark.scale = 1
	else
		shark.x = love.graphics.getWidth() + 200
		shark.y = 100 + (math.random() * (love.graphics.getHeight() - 100))
		shark.angle = math.pi
		shark.scale = -1
	end

	return shark
end

function Shark:update()
	self.x = self.x + math.cos(self.angle) * self.speed * delta
	self.y = self.y + math.sin(self.angle) * self.speed * delta

	if self.x < -400 or self.x > 1600 then sharks[self.id] = nil end
end

function Shark:draw()
	love.graphics.reset()
	love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale * .5, .5, 970, 920)
end