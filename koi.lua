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

	-- Start: Movement
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
	-- End: Movement

	if math.hcoca(self.x, self.y, 30, puffer.x, puffer.y, puffer.size) then
		if tangoing == 0 then
			love.gameover()
		else
			puffer:hurt()
		end
	end

	if #sharks > 0 then
		if math.hcoca(self.x, self.y, 30, sharks[1].x + 100 * sharks[1].scale, sharks[1].y, 100) then
			love.gameover()
		end
	end

	if self.id == 1 then
		while math.hcoca(self.x, self.y, 30, koi2.x, koi2.y, 30) do
			local dir = math.direction(self.x, self.y, koi2.x, koi2.y) + math.pi
			self.x = self.x + math.cos(dir) * 1
			self.y = self.y + math.sin(dir) * 1
			koi2.x = koi2.x + math.cos(dir + math.pi) * 1
			koi2.y = koi2.y + math.sin(dir + math.pi) * 1
		end
	end

	if tangoing > 0 then
		local distance, direction = 80, tangoing * 30

		if self.id == 1 then
			self.x = love.mouse.getX() + math.cos(direction) * distance
			self.y = love.mouse.getY() + math.sin(direction) * distance
			self.angle = direction - math.pi / 2
		else
			self.x = love.mouse.getX() + math.cos(direction + math.pi) * distance
			self.y = love.mouse.getY() + math.sin(direction + math.pi) * distance
			self.angle = direction + math.pi / 2

		end

		for i = 1, 2 do
			local sex = RainbowSex.create()
			local d = math.random(2 * math.pi)
			sex.x = self.x + math.cos(d) * 200
			sex.y = self.y + math.sin(d) * 200
		end
	end

	if math.random() < self.speed / 750 then
		local l = LilBubby.create()
		l.x = self.x - 20 + math.random() * (2 * 20)
		l.y = self.y - 20 + math.random() * (2 * 20)
	end
end

function Koi:draw()
	love.graphics.reset()

	local scale
	if tangoing > 0 then
		scale = .8
		love.graphics.setColor(255, 255, 255, 255)
		animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle + math.pi * 1.5, scale, scale, 64, 64)
		scale = 1.2
		love.graphics.setColor(255, 255, 255, 200)
		animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle + math.pi * 1.5, scale, scale, 64, 64)
		scale = 1.6
		love.graphics.setColor(255, 255, 255, 150)
		animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle + math.pi * 1.5, scale, scale, 64, 64)
		scale = 2
		love.graphics.setColor(255, 255, 255, 100)
		animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle + math.pi * 1.5, scale, scale, 64, 64)
		scale = 2.4
		love.graphics.setColor(255, 255, 255, 50)
		animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle + math.pi * 1.5, scale, scale, 64, 64)
	else
		scale = .8
		animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle + math.pi * 1.5, scale, scale, 64, 64)
	end

	if false and love.keyboard.isDown(' ') then
		love.graphics.setColor(0, 255, 0)
		love.graphics.circle('line', self.x, self.y, 30)
	end
end