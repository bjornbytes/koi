require 'util'
require 'pulse'
require 'scenery'
require 'koi'
require 'puffer'
require 'shark'
require 'bubble'

require 'anal'

toUpdate = {
	bubbles,
	meanBubbles,
	rainbowSexes,
	sharks,
	lilbubbies
}

function love.load()
	gt = 0
	gameover = 0

	koi1 = Koi.create()
	koi2 = Koi.create()

	koi1.color = {255, 0, 0}
	koi2.color = {0, 0, 255}

	koi1.x, koi1.y = 64, 64
	koi2.x, koi2.y = love.graphics.getWidth() - 64, love.graphics.getHeight() - 64

	koi1.id, koi2.id = 1, 2

	koi1.angle = 0
	koi2.angle = math.pi

	puffer = Puffer.create()

	bubbleTimer = 0
	bubbleRate = 1.1
	nextBubble = .25

	sprKoi = {}
	sprKoi[1] = love.graphics.newImage('img/blackKoi.png')
	sprKoi[2] = love.graphics.newImage('img/whiteKoi.png')

	animKoi = {}
	animKoi[1] = newAnimation(sprKoi[1], 128, 128, 0.1, 0)
	animKoi[2] = newAnimation(sprKoi[2], 128, 128, 0.1, 0)

	sprTail = love.graphics.newImage('img/pufferTail.png')
	sprFins = love.graphics.newImage('img/pufferFins.png')
	sprHead = love.graphics.newImage('img/pufferHead.png')

	sprShark = love.graphics.newImage('img/shark.png')

	sprBubbyBar = love.graphics.newImage('img/bubbleBar.png')

	animFins = newAnimation(sprFins, 1600, 1600, .15, 0)
	animTail = newAnimation(sprTail, 1600, 1600, .15, 0)
	animHead = newAnimation(sprHead, 1600, 1600, .1, 0)

	animShark = newAnimation(sprShark, 1600, 800, .2, 0)
	animBubbyBar = newAnimation(sprBubbyBar, 1200, 200, .075, 0)

	animFins:setMode('bounce')
	animTail:setMode('bounce')
	animShark:setMode('bounce')
	animBubbyBar:setMode('bounce')

	sandTile = love.graphics.newImage('img/sandTile.png')
	water = love.graphics.newImage('img/water.png')
	waterLight = love.graphics.newImage('img/waterLight.png')
	sprBubble = love.graphics.newImage('img/bubble.png')

	gameoverBG = love.graphics.newImage('img/gameoverBG.png')
	gameoverRestart = love.graphics.newImage('img/gameoverRestart.png')
	gameoverQuit = love.graphics.newImage('img/gameoverQuit.png')

	for i = 1, 8 do
		StarFish.create()
		Seaweed.create()
	end

	bubbleBar = 0
	bubbleBarMax = 10
	bubbleBarDisplay = 0

	sharkTimer = 0
	nextShark = 10

	tangoing = 0
	kinky = false

end

function love.update(dt)
	gt = (gt + dt)
	delta = dt

	if gameover > 0 then
		gameover = math.min(gameover + delta * 2, 1)
	end

	fx.pulse:send( "time", gt )

	for _, table in pairs(toUpdate) do
		for _, inst in pairs(table) do
			inst:update()
		end
	end

	koi1:update()
	koi2:update()
	puffer:update()

	if bubbleTimer > nextBubble then
		Bubble.create()

		bubbleTimer = 0
		nextBubble = math.max(bubbleRate - .1 + math.random() * .1, 0)
	end

	animKoi[1].update(animKoi[1], dt)
	animKoi[2].update(animKoi[2], dt)
	animFins:update(dt)
	animTail:update(dt)
	animBubbyBar:update(dt)
	animShark:update(dt)

	bubbleTimer = bubbleTimer + delta

	if tangoing > 0 then
		tangoing = math.max(tangoing - delta, 0)
	end

	sharkTimer = sharkTimer + delta
	if sharkTimer > nextShark then
		Shark.create()
		sharkTimer = 0
		nextShark = 20 - 10 + math.random(20)
	end

	bubbleBarDisplay = math.lerp(bubbleBarDisplay, bubbleBar, .05)

	if bubbleBar < bubbleBarMax then
		animBubbyBar:seek(1)
	end
end

function love.draw()
	love.graphics.reset()

	if tangoing > 0 then
		love.graphics.push()
		love.graphics.translate(-20 + math.random() * 40, -20 + math.random() * 40)
	end

	love.graphics.setPixelEffect(fx.pulse)
	love.graphics.setColor(255, 255, 255, 50)
	love.graphics.draw(sandTile, 0, 0)
	love.graphics.setPixelEffect()
	
	love.graphics.setColor(255, 255, 255, 60)
	for _, sf in pairs(starfish) do
		sf:draw()
	end

	love.graphics.setColor(255, 255, 255, 100)
	for _, sw in pairs(seaweed) do
		sw:draw()
	end

	if gameover > 0 then
		local scale = {
			x = love.graphics.getWidth() / gameoverBG:getWidth(),
			y = love.graphics.getHeight() / gameoverBG:getHeight()
		}

		love.graphics.setColor(255, 255, 255, (gameover / 1) * 255)
		love.graphics.draw(gameoverBG, 0, 0, 0, scale.x, scale.y)

		love.graphics.draw(gameoverRestart, 100, 600, 0, scale.x, scale.y)
		love.graphics.draw(gameoverQuit, 500, 600, 0, scale.x, scale.y)

		return
	end

	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(sandTile, 0, 0)

	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(water, 0, 0)

	koi1:draw()
	koi2:draw()
	puffer:draw()

	for _, bub in pairs(lilbubbies) do
		bub:draw()
	end

	for _, bubble in pairs(bubbles) do
		bubble:draw()
	end
	
	for _, shark in pairs(sharks) do
		shark:draw()
	end

	for _, sex in pairs(rainbowSexes) do
		sex:draw()
	end

	love.graphics.setColor(255, 255, 255, 160)
	love.graphics.draw(water, 0, 0)

		love.graphics.setColor(255, 255, 255, 255)
	animBubbyBar:draw(40, -30)

	local i = 0
	while i < (1200 - 145) * (bubbleBar / bubbleBarMax) do
		love.graphics.draw(sprBubble, 100 + i, 70, 0, 25 * 2.2/128, 25 * 2.2/128, sprBubble:getWidth() / 2 + 1, sprBubble:getHeight() / 2 + 1)
		i = i + 25
	end

	if tangoing > 0 then
		love.graphics.pop()
	end
end

function love.gameover()
	if gameover == 0 then
		gameover = .1
	end
	-- love.restart()
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
	bubbleRate = 2
	bubbleBar = 0
	bubbleBarMax = 10

	if #sharks > 0 then
		sharks[1] = nil
	end

	puffer.size = 40
	puffer.baseSpeed = 75
	puffer.speed = 0
	puffer.lastBubble = 0
end

function love.keypressed(key)
	if key == ' ' then
		if bubbleBar >= bubbleBarMax then
			bubbleBar = bubbleBar - bubbleBarMax
			tangoing = 3
			bubbleBarMax = bubbleBarMax + 15
		end
	end
end

function love.mousepressed(x, y, key)
	if gameover > 0 then
		if key == 'l' then
			if math.inside(x, y, 100, 600, gameoverRestart:getWidth(), gameoverRestart:getHeight()) then
				gameover = 0
				love.restart()
			else math.inside(x, y, 500, 500, gameoverQuit:getWidth(), gameoverQuit:getHeight())
				love.event.push('quit')
			end
		end
	end
end