StarFish = {}

starfish = {}

sfImages = {
	love.graphics.newImage('img/sfGreen.png'),
	love.graphics.newImage('img/sfMaroon.png'),
	love.graphics.newImage('img/sfPurple.png'),
	love.graphics.newImage('img/sfRed.png')
}

function StarFish.create()
	local idx = math.random(1, #sfImages)
	local sf = {
		x = math.random(0, love.graphics.getWidth()),
		y = math.random(0, love.graphics.getHeight()),
		angle = math.random(0, 2),
		scale = .5 + #starfish / 10,
		img = sfImages[idx]
	}

	setmetatable(sf, {__index = StarFish})

	starfish[#starfish + 1] = sf

	return sf
end

function StarFish:draw()
	love.graphics.draw(self.img, self.x, self.y, self.angle, self.scale, self.scale)
end

Seaweed = {}

seaweed = {}

function Seaweed.create()
	local sw = {
		x = math.random(0, love.graphics.getWidth()),
		y = love.graphics.getHeight() + 20,
		angle = -.1 + math.random() * .2,
		xscale = .5 + #seaweed / 10,
		yscale = .5 + #seaweed / 10,
		img = love.graphics.newImage('img/seaweed.png')
	}

	if math.random() < .5 then
		sw.xscale = sw.xscale * -1
	end

	setmetatable(sw, {__index = Seaweed})

	seaweed[#seaweed + 1] = sw

	return sw
end

function Seaweed:draw()
	love.graphics.draw(self.img, self.x, self.y, self.angle, self.xscale, self.yscale, self.img:getWidth() / 2, self.img:getHeight())
end