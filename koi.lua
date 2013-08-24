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
	if koiFormation == koiFormVert then
		local dis = math.abs(love.mouse.getX() - love.graphics.getWidth() / 2)
		if self.id == 1 then
			self.targetX = love.graphics.getWidth() / 2 - dis
			self.targetY = love.mouse.getY()
		else
			self.targetX = love.graphics.getWidth() / 2 + dis
			self.targetY = love.mouse.getY()
		end
		self.targetAngle = 0
	elseif koiFormation == koiFormCircle then
		local dis = math.abs(love.mouse.getX() - love.graphics.getWidth() / 2)
		if self.id == 1 then
			self.targetX = love.graphics.getWidth() / 2 + math.cos(koiCircleAngle) * dis
			self.targetY = love.mouse.getY() + math.sin(koiCircleAngle) * dis
			self.targetAngle = koiCircleAngle
		else
			self.targetX = love.graphics.getWidth() / 2 + math.cos(koiCircleAngle + math.pi) * dis
			self.targetY = love.mouse.getY() + math.sin(koiCircleAngle + math.pi) * dis
			self.targetAngle = koiCircleAngle + math.pi
		end
	end

	self.x = math.lerp(self.x, self.targetX, .075)
	self.y = math.lerp(self.y, self.targetY, .075)
	self.angle = math.anglerp(self.angle, self.targetAngle, .075)
end

function Koi:draw()
	love.graphics.reset()
	animKoi[self.id].draw(animKoi[self.id], self.x, self.y, self.angle, .8, .8, 64, 64)
end