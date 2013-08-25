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

sprKoi = {}
local loader = coroutine.create(function()
	loadingBG = love.graphics.newImage('img/loadingBG.png')
	menuBG = love.graphics.newImage('img/menuBG.png')
	coroutine.yield(1)
	sprLogo = love.graphics.newImage('img/logo.png')
	coroutine.yield(2)
	sprKoi[1] = love.graphics.newImage('img/blackKoi.png')
	coroutine.yield(3)
	sprKoi[2] = love.graphics.newImage('img/whiteKoi.png')
	coroutine.yield(4)
	sprTail = love.graphics.newImage('img/pufferTail.png')
	coroutine.yield(5)
	sprFins = love.graphics.newImage('img/pufferFins.png')
	coroutine.yield(6)
	sprHead = love.graphics.newImage('img/pufferHead.png')
	coroutine.yield(7)
	sprShark = love.graphics.newImage('img/shark.png')
	coroutine.yield(8)
	sprBubbyBar = love.graphics.newImage('img/bubbleBar.png')
	coroutine.yield(9)
	sandTile = love.graphics.newImage('img/sandTile.png')
	coroutine.yield(10)
	water = love.graphics.newImage('img/water.png')
	coroutine.yield(11)
	waterLight = love.graphics.newImage('img/waterLight.png')
	coroutine.yield(12)
	sprBubble = love.graphics.newImage('img/bubble.png')
	coroutine.yield(13)
	sprBandaid1 = love.graphics.newImage('img/bandaid1.png')
	coroutine.yield(14)
	sprBandaid2 = love.graphics.newImage('img/bandaid2.png')
	coroutine.yield(15)
	gameoverBG = love.graphics.newImage('img/gameoverBG.png')
	coroutine.yield(16)
	gameoverRestart = love.graphics.newImage('img/gameoverRestart.png')
	coroutine.yield(17)
	gameoverQuit = love.graphics.newImage('img/gameoverQuit.png')
	coroutine.yield(18)
	gameoverText = love.graphics.newImage('img/gameoverText.png')
	coroutine.yield(19)
	menuButtonPlay = love.graphics.newImage('img/buttonPlayHover.png')
	coroutine.yield(20)
	menuButtonCredits = love.graphics.newImage('img/buttonCredits.png')
	coroutine.yield(21)
	menuButtonCreditsHover = love.graphics.newImage('img/buttonCreditsHover.png')
	coroutine.yield(22)
	menuButtonQuit = love.graphics.newImage('img/buttonQuit.png')
	coroutine.yield(23)
	menuButtonQuitHover = love.graphics.newImage('img/buttonQuitHover.png')
	coroutine.yield(24)
	tutorialText = love.graphics.newImage('img/tutorialMain.png')
	coroutine.yield(25)
	tutorialButton = love.graphics.newImage('img/tutorialButton.png')
	coroutine.yield(26)
	backgroundSound = love.audio.newSource('sound/backgroundMusic.mp3', 'stream')
	coroutine.yield(27)
	aquariumSound = love.audio.newSource('sound/aquarium.mp3', 'stream')
	coroutine.yield(28)
	gameoverSound = love.audio.newSource('sound/gameoverSound.wav', 'stream')
	coroutine.yield(29)
	bubbleBarSound = love.audio.newSource('sound/bubbleBar.mp3', 'stream')
	coroutine.yield(30)
	rainbowSexSound = love.audio.newSource('sound/crazy.mp3', 'stream')
	coroutine.yield(31)
	bubbleSound = {}
	bubbleSound[1] = love.audio.newSource('sound/bubbles/pop1.mp3', 'stream')
	coroutine.yield(32)
	bubbleSound[2] = love.audio.newSource('sound/bubbles/pop2.mp3', 'stream')
	coroutine.yield(33)
	bubbleSound[3] = love.audio.newSource('sound/bubbles/pop3.mp3', 'stream')
	coroutine.yield(34)
	bubbleSound[4] = love.audio.newSource('sound/bubbles/pop4.mp3', 'stream')
	coroutine.yield(35)
	bubbleSound[5] = love.audio.newSource('sound/bubbles/pop5.mp3', 'stream')
	coroutine.yield(36)
	bubbleSound[6] = love.audio.newSource('sound/bubbles/pop6.mp3', 'stream')
	coroutine.yield(37)
	bubbleSound[7] = love.audio.newSource('sound/bubbles/pop7.mp3', 'stream')
	coroutine.yield(38)
	bubbleSound[8] = love.audio.newSource('sound/bubbles/pop8.mp3', 'stream')
	coroutine.yield(39)
	pauseResumeButton = love.graphics.newImage('img/buttonResume.png')
	coroutine.yield(40)
	pauseResumeButtonHover = love.graphics.newImage('img/buttonResumeHover.png')
end)

function love.load()
	-- Game States
	gt = 0
	gameover = 0
	win = 0
	menu = true
	tutorial = false
	credits = false
	loading = false

	-- Game Assets: Images and Animations
	while coroutine.status(loader) ~= 'dead' do
		local err, progress = coroutine.resume(loader)
		if progress then
			love.event.pump()
      for e, a, b, c, d in love.event.poll() do
        love.handlers[e](a, b, c, d)
      end
			love.graphics.clear()
			love.graphics.setColor(255, 255, 255, 255)
			if loadingBG then love.graphics.draw(loadingBG, 0, 0) end
			love.graphics.setColor(255, 255, 255, (progress / 40) * 255)
			if sprLogo then love.graphics.draw(sprLogo, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, (progress / 40) * math.pi * 2, 1, 1, 160, 160) end
			love.graphics.setColor(255, 255, 255, 60)
			love.graphics.rectangle('fill', love.graphics.getWidth() / 2 - 200, 600, (progress / 40) * 400, 20)
			love.graphics.setColor(255, 255, 255, 120)
			love.graphics.rectangle('line', love.graphics.getWidth() / 2 - 201, 599, 402, 22)
			love.graphics.present()
		end
	end

	animKoi = {}
	animKoi[1] = newAnimation(sprKoi[1], 128, 128, 0.1, 0)
	animKoi[2] = newAnimation(sprKoi[2], 128, 128, 0.1, 0)

	animFins = newAnimation(sprFins, 1600, 1600, .15, 0)
	animTail = newAnimation(sprTail, 1600, 1600, .15, 0)
	animHead = newAnimation(sprHead, 1600, 1600, .1, 0)

	animShark = newAnimation(sprShark, 1600, 800, .2, 0)
	animBubbyBar = newAnimation(sprBubbyBar, 1200, 200, .075, 0)

	animFins:setMode('bounce')
	animTail:setMode('bounce')
	animShark:setMode('bounce')
	animBubbyBar:setMode('bounce')

	menuButtonPlayAlpha = .8

	tutorialButtonAlpha = .75

	-- Game Assets: Audio
	backgroundSound:setLooping(true)
	aquariumSound:setLooping(true)
	love.audio.play(aquariumSound)

	paused = false

	-- Game Objects
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
	puffer.x, puffer.y = 640, 400

	bubbleTimer = 0
	bubbleRate = 0.9
	nextBubble = .25

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

	if paused then
		return
	end

	fx.pulse:send( "time", gt )
	fx.menuPulse:send( "time", gt )

	if menu then
		local x, y = love.mouse.getPosition()
		if math.inside(x, y, 400, 360, 480, 140) then
			menuButtonPlayAlpha = math.min(menuButtonPlayAlpha + delta, 1)
		else
			menuButtonPlayAlpha = math.max(menuButtonPlayAlpha - delta, .75)
		end

	elseif credits then
		--
	elseif gameover > 0 then
		gameover = math.min(gameover + delta * 15, 1)
	elseif win > 0 then
		win = math.min(win + delta * 15, 1)
	end

	if tutorial then
		if math.inside(love.mouse.getX(), love.mouse.getY(), 513, 603, 241, 67) then
			tutorialButtonAlpha = math.min(tutorialButtonAlpha + delta, 1)
		else
			tutorialButtonAlpha = math.max(tutorialButtonAlpha - delta, .75)
		end
	end

	if tutorial or menu or credits then
		if math.random() < .5 then
			local bubby = LilBubby.create(math.random(0, love.graphics.getWidth()), love.graphics.getHeight())
			bubby.hp, bubby.maxHp = 10, 10
		end

		for _, bubby in pairs(lilbubbies) do
			bubby:update()
		end

		return
	else
		if math.random() < .05 then
			local bubby = LilBubby.create(math.random(0, love.graphics.getWidth()), love.graphics.getHeight())
			bubby.hp, bubby.maxHp = 10, 10
		end
	end

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

	if menu then
		love.graphics.setPixelEffect(fx.menuPulse)
		love.graphics.setColor(255, 255, 255, 200)
		love.graphics.draw(menuBG, 0, 0)
		love.graphics.setPixelEffect()

		love.graphics.setColor(255, 255, 255, 255 * menuButtonPlayAlpha)
		love.graphics.draw(menuButtonPlay, 0, 0)
		love.graphics.setColor(255, 255, 255, 255)

		local x, y = love.mouse.getPosition()
		if math.inside(x, y, 470, 515, 340, 100) then
			love.graphics.draw(menuButtonCreditsHover, 0, 0)
		else
			love.graphics.draw(menuButtonCredits, 0, 0)
		end

		if math.inside(x, y, 470, 640, 340, 100) then
			love.graphics.draw(menuButtonQuitHover, 0, 0)
		else
			love.graphics.draw(menuButtonQuit, 0, 0)
		end

		for _, bub in pairs(lilbubbies) do
			bub:draw()
		end

		return
	elseif credits then
		love.graphics.setPixelEffect(fx.menuPulse)
		love.graphics.setColor(255, 255, 255, 200)
		love.graphics.draw(menuBG, 0, 0)
		love.graphics.setPixelEffect()

		return
	end

	-- Game State: Gameover
	if gameover > 0 then
		local scale = {
			x = love.graphics.getWidth() / gameoverBG:getWidth(),
			y = love.graphics.getHeight() / gameoverBG:getHeight()
		}

		local random = -2 + math.random() * 7

		love.graphics.setColor(255, 255, 255, (gameover / 1) * 255)
		love.graphics.draw(gameoverBG, 0, 0, 0, scale.x, scale.y)

		love.graphics.draw(gameoverRestart, 100, 600, 0, scale.x, scale.y)
		love.graphics.draw(gameoverQuit, 500, 600, 0, scale.x, scale.y)
		love.graphics.draw(gameoverText, 50 + random, 50 + random, 0, scale.x, scale.y)

		return
	end

	-- Game State: Win
	if win > 0 then
		-- win stuff
		return
	end

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

	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(sandTile, 0, 0)

	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(water, 0, 0)

	if tutorial then
		for _, bub in pairs(lilbubbies) do
			bub:draw()
		end
	end

	-- Game State: Tutorial
	if tutorial then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(tutorialText, 0, 0)
		love.graphics.setColor(255, 255, 255, tutorialButtonAlpha * 255)
		love.graphics.draw(tutorialButton, 0, 35)

		return
	end

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

	if paused then
		love.graphics.setColor(0, 0, 0, 180)
		love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		love.graphics.setColor(255, 255, 255, 200)
		love.graphics.draw(sprLogo, love.graphics.getWidth() / 2, 160, math.cos(gt / 4), 1, 1, 160, 160)

		love.graphics.setColor(255, 255, 255, 255)

		local x, y = love.mouse.getX(), love.mouse.getY()
		
		if math.inside(x, y, 470, 313, 340, 100) then
			love.graphics.draw(pauseResumeButtonHover, 0, -327)
		else
			love.graphics.draw(pauseResumeButton, 0, -327)
		end

		if math.inside(x, y, 470, 440, 340, 100) then
			love.graphics.draw(menuButtonQuitHover, 0, -200)
		else
			love.graphics.draw(menuButtonQuit, 0, -200)
		end
	end
end

function love.gameover()
	if gameover == 0 then
		love.audio.pause(backgroundSound)
		audio.play(gameoverSound)

		gameover = .1
	end
end

function love.restart()
	love.audio.stop(gameoverSound)
	love.audio.rewind(gameoverSound)
	
	if menu then
		if not muted then love.audio.resume(aquariumSound) end
		love.audio.stop(backgroundSound)
		love.audio.stop(gameoverSound)
	elseif not muted then
		love.audio.resume(backgroundSound)
	end

	koi1.color = {255, 0, 0}
	koi2.color = {0, 0, 255}

	koi1.x, koi1.y = 64, 64
	koi2.x, koi2.y = love.graphics.getWidth() - 64, love.graphics.getHeight() - 64
	puffer.x, puffer.y = 640, 400
	puffer.angle = math.random(2 * math.pi)
	puffer.speed = 30

	koi1.speed, koi2.speed = 0, 0

	for _, bubble in pairs(bubbles) do
		bubble:pop()
	end

	bubbleTimer = 0
	bubbleRate = .9
	nextBubble = .25

	bubbleBar = 0
	bubbleBarMax = 10
	bubbleBarDisplay = 0

	sharkTimer = 0
	nextShark = 10

	if #sharks > 0 then
		sharks[1] = nil
	end

	puffer.hp = 5
	puffer.size = 60
	puffer.baseSpeed = 75
	puffer.speed = 0
	puffer.lastBubble = 0
	puffer.bandaids = {}
end

function love.keypressed(key)
	if key == ' ' and not paused then
		if bubbleBar >= bubbleBarMax then
			love.audio.pause(bubbleBarSound)
			love.audio.rewind(bubbleBarSound)

			audio.play(rainbowSexSound)

			bubbleBar = bubbleBar - bubbleBarMax
			tangoing = 3
			bubbleBarMax = bubbleBarMax + 15
		end
	elseif key == 'm' then
		muted = not muted

		if muted then
			love.audio.pause()
		else
			if not menu then
				love.audio.resume(backgroundSound)
			end
			
			love.audio.resume(aquariumSound)
		end
	elseif (key == 'p' or key == 'escape') and (not menu and not tutorial and not credits) then
		paused = not paused
	end
end

function love.mousepressed(x, y, key)
	if menu then
		if math.inside(x, y, 400, 360, 480, 140) then
			tutorial = true
			menu = false
		elseif math.inside(x, y, 470, 515, 340, 100) then
			credits = true
			menu = false
		elseif math.inside(x, y, 470, 640, 340, 100) then
			love.event.push('quit')
		end
	elseif credits then
		--
	elseif gameover > 0 then
		if key == 'l' then
			local scale = {
				x = love.graphics.getWidth() / gameoverBG:getWidth(),
				y = love.graphics.getHeight() / gameoverBG:getHeight()
			}

			if math.inside(x, y, 100, 600, gameoverRestart:getWidth() * scale.x, gameoverRestart:getHeight() * scale.y) then
				gameover = 0
				love.restart()
			elseif math.inside(x, y, 500, 600, gameoverQuit:getWidth() * scale.x, gameoverQuit:getHeight() * scale.y) then
				menu = true
				love.restart()
				gameover = 0
			end
		end
	elseif tutorial then
		if key == 'l' then
			if math.inside(x, y, 513, 603, 241, 67) then
				tutorial = false
				love.restart()
				audio.play(backgroundSound)
			end
		end
	elseif paused then
		if key == 'l' then
			-- Resume
			if math.inside(x, y, 470, 313, 340, 100) then
				paused = false
			-- Quit
			elseif math.inside(x, y, 470, 440, 340, 100) then
				menu = true
				paused = false
				love.restart()
			end
		end
	end
end