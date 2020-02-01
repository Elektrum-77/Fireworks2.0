
local function randomColor(c) return {c[1]-0.2+math.random()*0.4,c[2]-0.2+math.random()*0.4,c[3]-0.2+math.random()*0.4} end
local function random(a) return a*(math.random()-0.5) end


local particule = {
	x=0,y=0,vx=0,vy=0,ax=0,ay=0,lifetime=0,color=0,texture=love.graphics.newImage("particule.png"),
	new=function(self,t)
		p={_mt={__index=self}}
		for k,v in pairs(self) do if type(v)~='function' then p[k] = t[k] and t[k] or v end end
		return setmetatable(p, p._mt)
	end,
	draw=function(self, timer)
		local color=randomColor(self.color)
		-- love.graphics.setColor(self.color[1],self.color[2],self.color[3],1-(timer/self.lifetime)*(timer/self.lifetime))
		love.graphics.setColor(color[1],color[2],color[3],1-math.sqrt(timer/self.lifetime))
		-- love.graphics.setColor(self.color[1],self.color[2],self.color[3],0.1)
		love.graphics.draw(self.texture, self.x, self.y)
	end,
	update=function(self, dt)
		self.x=self.x+self.vx*dt*60
		self.y=self.y+self.vy*dt*60
		self.vx=self.ax*dt*60+self.vx
		self.vy=self.ay*dt*60+self.vy
	end,
}

local firework=
{
	time=0,p=0,
	x=SW/2,y=SH/2,vx=6,vy=6,ax=-0.1,ay=-0.1,lifetime=1.2,color={1,1,1},
	dx=5,dy=5,dvx=2,dvy=2,dax=0.01,day=0.01,dlifetime=0.2,
	new=function(self,t)
		math.randomseed(os.time()+math.random(100000))
		local e = {_mt={__index=self}}
		for k,v in pairs(self) do if type(v)~='function' then e[k] = t[k] and t[k] or v end end
		e.p={}
		for _=0,40 do
			local a = math.random()*math.pi*2
			table.insert(e.p, particule:new{
				x=e.x+random(e.dx),y=e.y+random(e.dy),
				vx=math.cos(a)*e.vx+random(e.dvx),vy=math.sin(a)*e.vy+random(e.dvy),
				ax=math.cos(a)*e.ax+random(e.dax),ay=math.sin(a)*e.ay+random(e.day),
				lifetime=e.lifetime+random(e.dlifetime),
				color=e.color
			})
		end
		return setmetatable(e, e._mt)
	end,
	update=function(self,dt)
		self.time=self.time+dt
		for i,p in ipairs(self.p) do
			p:update(dt)
			if p.lifetime<self.time then table.remove(self.p, i) end
		end
	end,
	draw=function(self)
		for i,p in ipairs(self.p) do
			p:draw(self.time)
		end
	end,
}

return firework
