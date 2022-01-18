local intro = require "intro"
intro:init()

love.graphics.setBackgroundColour(intro.hex("152634"))

local player = {x=love.graphics.getWidth()/2, y=love.graphics.getHeight()/2, xV=0, yV=0, dir = 0, dirV = 0, fuel = 100}
player.img = love.graphics.newImage("spaceship.png")

local particles = love.graphics.newParticleSystem(love.graphics.newImage("particle.png"), 3200)
particles:setParticleLifetime(0.01, 0.1)
particles:setSpeed(400, 700)
particles:setColors({1, 1, 0}, {1, 0.3, 0}, {0.5, 0.5, 0.5, 0})
particles:setSizes(0.2, 1)

local vignette = {img = love.graphics.newImage("vignette.png"), intensity = 1}

function love.update(dt)
	intro:update(dt)
	particles:update(dt)

	if love.keyboard.isDown("w") and player.fuel >= 1 then
		player.yV = player.yV - math.cos(player.dir)
		player.xV = player.xV + math.sin(player.dir)

		player.dirV = player.dirV * 0.9

		particles:setDirection(player.dir+math.pi/2)
		particles:setRotation(player.dir)
		for i=1, 8 do
			particles:moveTo(player.x - math.sin(player.dir)*20*i/30, player.y + math.cos(player.dir)*20*i/30)
			particles:emit(1, player.x, player.y)

			vignette.intensity = math.min(vignette.intensity + 0.01, 1)
		end

		player.fuel = player.fuel - 1
	end

	if player.fuel >= 0.05 then
		if love.keyboard.isDown("d") then
			player.dirV = player.dirV + math.pi/100
			player.fuel = player.fuel - 0.05
		end

		if love.keyboard.isDown("a") then
			player.dirV = player.dirV - math.pi/100
			player.fuel = player.fuel - 0.05
		end
	end

	player.x = player.x + player.xV
	player.y = player.y + player.yV

	player.xV = player.xV * 0.99
	player.yV = player.yV * 0.99

	player.dir = player.dir + player.dirV
	if player.fuel >= 0.05 then 
		player.dirV = player.dirV * 0.9 
	end

	if intro.phase > 1 then vignette.intensity = vignette.intensity + (0.45 - vignette.intensity)*0.1 end
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(-player.x+love.graphics.getWidth()/2 - player.xV*2, -player.y+love.graphics.getHeight()/2 - player.yV*2)
	love.graphics.draw(particles)
	love.graphics.draw(player.img, player.x, player.y, player.dir, 0.4, nil, player.img:getWidth()/2, player.img:getHeight()/2)
	love.graphics.pop()

	love.graphics.setColour(1,1,1,vignette.intensity)
	love.graphics.draw(vignette.img, 0,0, nil, love.graphics.getWidth()/vignette.img:getWidth(), love.graphics.getHeight()/vignette.img:getHeight())

	-- intro.pprint(player.fuel)
	love.graphics.setColour(1,1,1)
	local padding = 2
	love.graphics.setLineWidth(padding)
	love.graphics.rectangle("fill", 10+padding*2, 10+padding*2, (150-padding*4)/100*player.fuel, 20-padding*4)
	love.graphics.rectangle("line", 10, 10, 150, 20)

	-- intro.pprint(vignette.intensity, 100)

	intro:draw()
end

function love.keypressed(k)
	if k == "r" then
		player = {x=love.graphics.getWidth()/2, y=love.graphics.getHeight()/2, xV=0, yV=0, dir = 0, dirV = 0, fuel = 100}
		player.img = love.graphics.newImage("spaceship.png")
	end	
end