Koi = {}

function Koi.create()
	local koi = {
		x = 0,
		y = 0,
		targetX = 0,
		targetY = 0,
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
	if koiFormation == koiFormVert then
		local dis = math.abs(love.mouse.getX() - love.graphics.getWidth() / 2)
		if self.id == 1 then
			self.targetX = love.graphics.getWidth() / 2 - dis
			self.targetY = love.mouse.getY()
		else
			self.targetX = love.graphics.getWidth() / 2 + dis
			self.targetY = love.mouse.getY()
		end
	elseif koiFormation == koiFormCircle then
		local dis = math.abs(love.mouse.getX() - love.graphics.getWidth() / 2)
		if self.id == 1 then
			self.targetX = love.graphics.getWidth() / 2 + math.cos(koiCircleAngle) * dis
			self.targetY = love.mouse.getY() + math.sin(koiCircleAngle) * dis
		else
			self.targetX = love.graphics.getWidth() / 2 + math.cos(koiCircleAngle + math.pi) * dis
			self.targetY = love.mouse.getY() + math.sin(koiCircleAngle + math.pi) * dis
		end
	end

	self.x = math.lerp(self.x, self.targetX, .075)
	self.y = math.lerp(self.y, self.targetY, .075)
end

function Koi:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.circle('fill', self.x, self.y, 30)
end