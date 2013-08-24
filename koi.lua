Koi = {}

function Koi.create()
	local koi = {
		x = 0,
		y = 0,
		targetX = 0,
		targetY = 0,
		angle = 0,
		targetAngle = 0,
		speed = 0,
		sexy = false,
		color = {255, 255, 255},
		angleSwitch = 0
	}

	setmetatable(koi, {__index = Koi})

	return koi
end

function Koi:update()
	self.x = self.x + math.cos(self.angle) * self.speed * delta
	self.y = self.y + math.sin(self.angle) * self.speed * delta

	local x, y = love.mouse.getPosition()

	if math.distance(self.x, self.y, x, y) > 20 then
		local diff = math.anglediff(self.angle, math.direction(self.x, self.y, x, y))
		self.angle = self.angle + diff * delta * (math.distance(self.x, self.y, x, y) * .1)
	end

	if love.mouse.isDown('l') and math.distance(self.x, self.y, x, y) > 60 then
		self.speed = math.min(self.speed + 500 * delta, 500)
		self.angleSwitch = self.angleSwitch + delta
		if self.angleSwitch < 1 then
			if self.id == 1 then
				self.angle = self.angle + 2 * delta
			else
				self.angle = self.angle - 2 * delta
			end
		else
			if self.id == 1 then
				self.angle = self.angle - 2 * delta
			else
				self.angle = self.angle + 2 * delta
			end
		end

		if self.angleSwitch > 2 then self.angleSwitch = 0 end
	else
		self.speed = math.max(self.speed - 500 * delta, 50)
	end

	if math.hcoca(self.x, self.y, 30, puffer.x, puffer.y, puffer.size) then
		love.gameover()
	end
end

function Koi:draw()
	love.graphics.reset()
	animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle + math.pi * 1.5, .8, .8, 64, 64)

	if love.keyboard.isDown(' ') then
		love.graphics.setColor(0, 255, 0)
		love.graphics.circle('line', self.x, self.y, 30)
	end
end