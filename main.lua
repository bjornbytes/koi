require 'util'
require 'koi'
require 'bubble'
require 'bubbleformations'
require 'wall'

require 'anal'

koiFormVert = 1
koiFormCircle = 2

toUpdate = {
	bubbles,
	meanBubbles,
	rainbowSexes
}

function love.load()
	koi1 = Koi.create()
	koi2 = Koi.create()

	koi1.color = {255, 0, 0}
	koi2.color = {0, 0, 255}

	koi1.x, koi1.y = 64, 64
	koi2.x, koi2.y = love.graphics.getWidth() - 64, love.graphics.getHeight() - 64

	koi1.id, koi2.id = 1, 2

	koi1.angle = 0
	koi2.angle = math.pi

	bubbleTimer = 0
	meanBubbleTimer = 0

	koiFormation = koiFormVert
	koiCircleAngle = 0

	sprKoi = {}
	sprKoi[1] = love.graphics.newImage('blackKoi.png')
	sprKoi[2] = love.graphics.newImage('blackKoi.png')

	animKoi = {}
	animKoi[1] = newAnimation(sprKoi[1], 128, 128, 0.1, 0)
	animKoi[2] = newAnimation(sprKoi[2], 128, 128, 0.1, 0)
end

function love.update(dt)
	delta = dt

	for _, table in pairs(toUpdate) do
		for _, inst in pairs(table) do
			inst:update()
		end
	end

	koi1:update()
	koi2:update()

	for _, fc in pairs(formationCreators) do
		fc:update()
	end

	if meanBubbleTimer > 1 then
		local b = MeanBubble.create()
		meanBubbleTimer = 0
	end

	if koiFormation == koiFormCircle then
		koiCircleAngle = koiCircleAngle + (2 * math.pi * delta)
	end

	animKoi[1].update(animKoi[1], dt)
	animKoi[2].update(animKoi[2], dt)
end

function love.draw()
	love.graphics.setColor(50, 50, 100)
	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	local w2 = love.graphics.getWidth() / 2
	love.graphics.setColor(255, 255, 255, 40)
	love.graphics.line(w2, 0, w2, love.graphics.getHeight())

	if koiFormation == koiFormVert then
		local dis = math.abs(love.mouse.getX() - w2)
		love.graphics.line(w2 - dis, 0, w2 - dis, love.graphics.getHeight())
		love.graphics.line(w2 + dis, 0, w2 + dis, love.graphics.getHeight())
	elseif koiFormation == koiFormCircle then
		local dis = math.abs(love.mouse.getX() - w2)
		love.graphics.circle('line', w2, love.mouse.getY(), dis / 2)
	end

	koi1:draw()
	koi2:draw()

	for _, rsex in pairs(rainbowSexes) do
		rsex:draw()
	end

	for _, bubble in pairs(bubbles) do
		bubble:draw()
	end

	for _, mbubble in pairs(meanBubbles) do
		mbubble:draw()
	end

	for _, wall in pairs(walls) do
		wall:draw()
	end
end

function love.gameover()
	love.restart()
end

function love.restart()
	koi1.color = {255, 0, 0}
	koi2.color = {0, 0, 255}

	koi1.x, koi1.y = 64, 64
	koi2.x, koi2.y = love.graphics.getWidth() - 64, love.graphics.getHeight() - 64

	koi1.speed, koi2.speed = 0, 0

	for _, bubble in pairs(bubbles) do
		bubble:pop()
	end

	bubbleTimer = 0
	meanBubbleTimer = 0

	bubbles = {}
	meanBubbles = {}
end

function love.keypressed(key)
	if key == '1' then
		koiFormation = koiFormVert
	elseif key == '2' then
		koiFormation = koiFormCircle
	end
end