require 'util'
require 'koi'
require 'bubble'
require 'wall'

function love.load()
	koi1 = Koi.create()
	koi2 = Koi.create()

	koi1.color = {255, 0, 0}
	koi2.color = {0, 0, 255}

	koi1.x, koi1.y = 64, 64
	koi2.x, koi2.y = love.graphics.getWidth() - 64, love.graphics.getHeight() - 64
end

function love.update(dt)
	delta = dt

	for _, bubble in pairs(bubbles) do
		bubble:update()
	end

	koi1:update()
	koi2:update()
end

function love.draw()
	koi1:draw()
	koi2:draw()

	for _, bubble in pairs(bubbles) do
		bubble:draw()
	end

	for _, wall in pairs(walls) do
		wall:draw()
	end
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		local b = Bubble.activate()
		if b then
			b.x = x
			b.y = y
		end
		print(nextbubble)
	end
end