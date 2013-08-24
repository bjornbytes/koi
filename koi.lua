Koi = {}

function Koi.create()
	local koi = {
		x = 0,
		y = 0,
		angle = 0,
		speed = 0,
		sexy = false,
		color = {255, 255, 255},
		angleSwitch = 0
	}

	setmetatable(koi, {__index = Koi})

	return koi
end

function Koi:update()
	self:move()
end

function Koi:move()
	self.x = self.x + math.cos(self.angle) * self.speed * delta
	self.y = self.y + math.sin(self.angle) * self.speed * delta

	if self.sexy then
		local x, y = love.mouse.getPosition()

		self.angle = math.anglerp(self.angle, math.direction(self.x, self.y, x, y), .085)
		self.speed = math.min(self.speed + 500 * delta, 1000)

		self.angleSwitch = self.angleSwitch + delta
		if self.angleSwitch > .5 then
			local r = math.random()
			if self.id == 1 and r < .5 then
				self.angle = self.angle + 3 * delta
			else
				self.angle = self.angle - 3 * delta
			end

			if self.id == 2 and r < .5 then 
				self.angle = self.angle - 3 * delta
			else
				self.angle = self.angle + 3 * delta
			end

			if self.angleSwitch > 1 then
				self.angleSwitch = 0
			end
		end

		if math.distance(self.x, self.y, x, y) < 200 then
			self.speed = math.max(self.speed - 600 * delta, 500)
		end
	else
		self.speed = math.lerp(self.speed, 0, .02)
	end
end

function Koi:collide()
	--
end

function Koi:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.circle('fill', self.x, self.y, 30)
end