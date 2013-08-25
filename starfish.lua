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
		img = sfImages[idx]
	}

	setmetatable(sf, {__index = StarFish})

	starfish[#starfish + 1] = sf

	return sf
end

function StarFish:draw()
	love.graphics.draw(self.img, self.x, self.y)
end