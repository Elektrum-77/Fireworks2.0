io.stdout:setvbuf("no")

ColorList={}
ColorFile=io.open("ColorList.txt", "r")
ColorFile.read(ColorFile)
ColorFile.read(ColorFile)

function love.load()
	love.window.setFullscreen(true, "desktop")
	--love.window.setMode(0, 0)
	love.mouse.setVisible(false)
	love.graphics.setBackgroundColor(0.05,0.01,0.1)
	love.graphics.setDefaultFilter("nearest","nearest",16)
	SW,SH=love.graphics.getDimensions()

	for line in ColorFile.lines(ColorFile) do
		local C,buff,i,start={},"",0,1
		while i<#line+1 do
			i=i+1
			if line:sub(i,i)=="," then
				buff=buff..line:sub(start,i-1)
				start=i+1
				table.insert(C,buff)
				buff=""
			end
		end
		table.insert(ColorList,{tonumber(C[1]),tonumber(C[2]),tonumber(C[3])})
		print("Color loading ;","R :",C[1],"G :",C[2],"B :",C[3])
	end
	

	Fireworks = require "Fireworks"
	FireworksList = {Fireworks:new{}}
	timer=0
end

function love.draw()
	for i,v in ipairs(FireworksList) do
		v:draw()
	end
	love.graphics.setColor(1,1,1)
	love.graphics.print(love.timer.getFPS(),20,20)
end

function love.update(dt)
	timer=timer+dt
	for i,v in ipairs(FireworksList) do
		v:update(dt)
		if #v.p == 0 then table.remove(FireworksList, i) end
	end
	-- local limit=math.random()
	local limit=math.random()*0.0
	if timer>limit then
		timer=timer-limit
		-- for i=1,math.random(7) do table.insert(FireworksList, Fireworks:new{}) end
		for i=1,8 do
			x,y= math.random()*love.graphics.getWidth(), math.random()*love.graphics.getHeight()
			for i=1,2 do
				table.insert(FireworksList, Fireworks:new{x=x,y=y,color=ColorList[math.random(#ColorList)]})
			end
		end
		-- for i=1,math.random(5) do table.insert(FireworksList, Fireworks:new(math.random()*love.graphics.getWidth(),math.random()*love.graphics.getHeight(),1.5,4,2)) end
	end
end
