pico-8 cartridge // http://www.pico-8.com
version 14
__lua__

function _init()
	current_island = 1
	update_island = false
	imunetemp = 0
 startisland = false
	spr_index = 23
	refreshenemydist = 100
	genenemydist = 50
	piscapisca = 0
	stage1 = true
	stage2 = false
	stage3 = false
	stage4 = false
	enemy_sprite_control = 0
	score = 0
	waveframe = 0
	wavespr = 3

	
	p = {
		x = 60,
		y = 100,
		vx = 0,
		vy = 0,
		vidas = 3,
		imune = false,
		
		imune_frames = 120,
		
		spr_it = {26,27,28},
		spr_it_costas = {42,43,44},
		spr_it_idle = {48,49, 50},
		
		walking = false,
		right = false,
		idle = true,
		decostas = false,
		invis = false,
		voltarbarco = false
	}

	lives_frames = 0 
  lives = {} 
   
  local x = 0 
  repeat 
    add(lives,85) 
    x += 1 
  until x >= p.vidas
	
	
	cam = {
		x = 16,
		y = 0
	}

	initialize_island_1()
	
	encofra = 0
	spricor = 0
	
	spr_current_i = 0

counter = 0
fader1 = 0
fader2 = 1
fader3 = 0
fader4 = 1
counter2 = 0
counter3 = 0
counter4 = 0
fader5 = 0
fader6 = 1
fader7 = 0
fader8 = 1
fader9 = 0
fader10 = 1
fader11 = 0
fader12 = 1
trans3_2 = false
trans3_4 = false
trans1_2 = false
trans4_1 = false
gameover = false
attacking = false	
	
	
trans2_3 = false
trans2_4 = false
counter5 = 0
counter6 = 0
boat={
x = 7*8,
y = 7*8,
lastx = 7*8,
lasty = 7*8,
vx = 0,
vy = 0,
ax = 0,
ay = 0,
width = 8,
height = 16, 
collided = false,
frame = 0,
invulnerable = false,
boost = false,
res = 1,
distancex = 0,
distancey = 0,
island = false
}

enemy = {
x = 60,
y = 60,
width = 8,
height = 8,
}
islandx = 0
islandy = 0
island_spawned = false
distance_generate = 100
generate_offset = 150
generate_reset = 500

enemylist = {}

enemynumber = 5

for i=1, enemynumber do

	add(enemylist,
	{i*20+rnd(1)*20,
	i*20+rnd(1)*20,
	8,8,0,0,0
	,55,0,
	0,0})
	
end

lastmoved = 0
music_pattern = 0
music(0)
end

function initialize_island_1()
comidas = {}
	
	comida = {}
	comida.x = 3*8
	comida.y = 10*8
	add(comidas, comida)

	
	comida = {}
	comida.x = 23*8
	comida.y = 10*8
	add(comidas, comida)
	
	tesouros = {}
	
	tesouro = {}
	tesouro.x = 4*8
	tesouro.y = 2*8
	add(tesouros, tesouro)


	tesouro = {}
	tesouro.x = 11*8
	tesouro.y = 4*8
	add(tesouros, tesouro)

	
	tesouro = {}
	tesouro.x = 27*8
	tesouro.y = 10*8
	add(tesouros, tesouro)
	
	
	tesouro = {}
	tesouro.x = 27*8
	tesouro.y = 2*8
	add(tesouros, tesouro)
	
	e = {}
	proj = {}
	
	for i=1,2 do
		add(e, {i*10, 250-i+5})
	end
end

function initialize_island_2()
	comidas = {}
	
	comida = {}
	comida.x = 4*8
	comida.y = 23*8
	add(comidas, comida)

	
	comida = {}
	comida.x = 12*8
	comida.y = 25*8
	add(comidas, comida)
	
	tesouros = {}
	
	tesouro = {}
	tesouro.x = 25*8
	tesouro.y = 18*8
	add(tesouros, tesouro)


	tesouro = {}
	tesouro.x = 17*8
	tesouro.y = 20*8
	add(tesouros, tesouro)

	
	tesouro = {}
	tesouro.x = 22*8
	tesouro.y = 25*8
	add(tesouros, tesouro)
	
	
	tesouro = {}
	tesouro.x = 27*8
	tesouro.y = 2*8
	add(tesouros, tesouro)
	
	e = {}
	proj = {}
	
	for i=1,2 do
		add(e, {i*10, 250-i+5})
	end
	
end

function initialize_island_3()
	comidas = {}
	
	comida = {}
	comida.x = 39*8
	comida.y = 10*8
	add(comidas, comida)

	
	comida = {}
	comida.x = 39*8
	comida.y = 1*8
	add(comidas, comida)
	
	tesouros = {}
	
	tesouro = {}
	tesouro.x = 60*8
	tesouro.y = 5*8
	add(tesouros, tesouro)


	tesouro = {}
	tesouro.x = 47*8
	tesouro.y = 8*8
	add(tesouros, tesouro)
	
	e = {}
	proj = {}
	
	for i=1,2 do
		add(e, {i*10, 250-i+5})
	end
	
end

function solid(x, y)

 -- grab the cell value
 val=mget(flr(x/8),flr(y/8))
 
 -- check if flag 1 is set
 return fget(val, 1)
 
end



function _draw()
cls()
	if(stage1) then
	
	 if(music_pattern != 0) then
	  music_pattern = 0
	  music(-1,5000)
	  music(0,5000)
	  end

		if(trans1_2) then
			transitionstate1_2()
		end
		
		drawmainmenu()
	elseif(stage2) then
	
	if(music_pattern != 0) then
	  music_pattern = 0
	  music(-1,5000)
	  music(0,5000)
	  end
	
		if(trans1_2) then
			transitionstate1_2()
		end
		drawsea()
		
		
		
		drawresourcebar1()

		local lives_x = boat.x - 62 
  
   		x = 0 
   		repeat 
   		spr( 85, lives_x,boat.y-62) 
       	lives_x += 10 
       	x += 1 
   		until x > p.vidas - 1  

		if(trans2_3) then
			transitionstate2_3()
		end
		if(trans2_4) then
			transitionstate2_4()
		end
		if(trans3_2) then
			transitionstate3_2()
		end
	elseif(stage3) then
	
	if(music_pattern != 8) then
	  music_pattern = 8
	  music(-1,5000)
	  music(8,5000)
	  end
	
		if(trans2_3) then
			transitionstate2_3()
		end
		if(trans3_4) then
			transitionstate3_4()
		end
		if(trans3_2) then
			transitionstate3_2()
		end

		drawisland()
		i = -30

	elseif(stage4) then
	
	if(music_pattern != 6) then
	  music_pattern = 6
	  music(-1,5000)
	  music(6,5000)
	  end
	  
	  
		if(trans2_4) then
			transitionstate2_4()
		end
		if(trans3_4) then
			transitionstate3_4()
		end
		if(trans4_1) then
			transitionstate4_1()
		end

		drawgameover()
		
	end
end

function drawresourcebar1()
 res_y = boat.y-54
	res_x = boat.x-62

	rectfill(res_x+2,res_y+2,res_x+33-(1-boat.res)*31,res_y+7,8)
	rectfill(res_x+33-(1-boat.res)*31,res_y+2,res_x+33,res_y+7,7)	
	
	res_y -=6		
	spr(173,res_x,res_y)
	spr(174,res_x+8,res_y)
 spr(174,res_x+16,res_y)
 spr(174,res_x+24,res_y)
 spr(175,res_x+32,res_y)
 
 res_y += 8
 spr(189,res_x,res_y)
	spr(190,res_x+8,res_y)
	spr(190,res_x+16,res_y)
 spr(190,res_x+24,res_y)
 spr(191,res_x+32,res_y)
end

function drawresourcebar2()
	rectfill(cam.x+4,cam.y+17,cam.x+35-(1-boat.res)*31,cam.y+22,8)
	rectfill(cam.x+35-(1-boat.res)*31,cam.y+17,cam.x+35,cam.y+22,7)	
		
	res_y = (cam.y+8)
	res_x = (cam.x+2)
	spr(173,res_x,res_y)
	spr(174,res_x+8,res_y)
 	spr(174,res_x+16,res_y)
 spr(174,res_x+24,res_y)
 spr(175,res_x+32,res_y)
 
 res_y += 8
 spr(189,res_x,res_y)
	spr(190,res_x+8,res_y)
	spr(190,res_x+16,res_y)
 spr(190,res_x+24,res_y)
 spr(191,res_x+32,res_y)
end

function drawgameover()
	map(65,1,8,8,14,14)
	camera(0,0)

	zspr(92,1,1,45,30,1.5) -- g
	zspr(75,1,1,52,30,1.5) -- a
	zspr(107,1,1,59,30,1.5) -- m
	zspr(79,1,1,66,30,1.5) -- e
	zspr(109,1,1,50,45,1.5) -- o
	zspr(125,1,1,57,45,1.5) --v
	zspr(79,1,1,64,45,1.5) --e
	zspr(121,1,1,71,45,1.5) --r
	print("score:",45,85,0)
	print(scorefin,55,95,0)

	if(btn(5)) then
		
		_init()
		

		
	end
	
	



end

function drawisland()

	

 --camera
 if current_island == 1 then
 cam.x = p.x-4*8
 if cam.x < 0 then
 	cam.x = 0
 end
 if cam.x > 16*8 then
 	cam.x = 16*8
 end	
 else
 cam.x = p.x-4*8
  if cam.x < 0 then
  cam.x = 0
  end
  if cam.x >16*8 then
  cam.x = 16*8
  end
 end
 
if(current_island == 1) then
cam.y = 0
 else
 cam.y = 16*8
 end
 
 camera(cam.x,cam.y)

	spricor+=1
	encofra+=1
	
	--decide sprits
	
	if p.walking then
		current_sprite = p.spr_it
	end
	if p.idle then
		current_sprite = p.spr_it_idle
	end
	if p.decostas then
		current_sprite = p.spr_it_costas
	end

	cls()
	if(current_island == 1) then
		map(0,0,0,0,32,16)
	end
	
	if(current_island == 2) then
		map(0,16,0,16*8,32,16)
	end
	
	
	for comida in all(comidas) do
		spr(20, comida.x, comida.y)
	end
	
	for tesouro in all(tesouros) do
		spr(68, tesouro.x, tesouro.y)
	end
	
	for comida in all(comidas) do
		if(dist(
			p.x, comida.x, p.y, comida.y))
			< 5 and dist(
			p.x, comida.x, p.y, comida.y) > 0
		then
			del(comidas, comida)
			boat.res+=0.4
		end
	end

	checkforcolision()
	
	for tesouro in all(tesouros) do
			
			if 
				dist(p.x, tesouro.x,
				p.y, tesouro.y)<5 
				and
				dist(p.x, tesouro.x,
				p.y, tesouro.y)>0
				
		then
			del(tesouros, tesouro)
			score += 1000
		end
		
	end
	
	 --lives 
   
  local lives_x = cam.x+2 
 
 x = 0 
  for l in all(lives) do 
    
   spr( l, lives_x,cam.y+2) 
   x += 1 
    lives_x += 10 
     
  end 
	
	print(score)
	

		
 --animation	
	if spricor % 15 == 0 then
		max_spr = #current_sprite
		if spr_current_i >= max_spr
					or spr_current_i == 0
		then
			spr_current_i = 1
		else
			spr_current_i +=1
		end
	end
	--draw player
	if p.imune_frames < 120 then
		if p.imune_frames % 3 == 0 then
			spr(current_sprite[spr_current_i],p.x-4,p.y-4,1,1,p.right,false)	
		end
	else
		spr(current_sprite[spr_current_i],p.x-4,p.y-4,1,1,p.right,false)
	end

 --shoot enimies


	


	if encofra % 60 == 0 then
		for v in all(e) do
			addproj(v[1], v[2], p.x, p.y)
		end
		encofra = 0
	end
	
	for seta in all(proj) do
		spr_n = 132
		flip_h = false
		flip_v = false
		
		if seta.vx < 0 then
			flip_h = true
		end
		
		if seta.vy < 0 then
			if -0.5 < seta.vx and seta.vx < 0.5
			then
				spr_n = 133
			end
		end
		
		if seta.vy > 0 then
			if -0.5 < seta.vx and seta.vx < 0.5
			then
				spr_n = 133
				flip_v = true
			end
		end
		--draw seta
		spr(spr_n,seta.x, seta.y,1,1,flip_h,flip_v)
	
		--player hit
		if(p.imune_frames < 120) then
			p.imune_frames -= 1
		end
		if(p.imune_frames <= 0) then
					p.imune_frames = 120
			end
			if(dist(seta.y,p.y,seta.x,p.x)<2)	then
				if(p.imune_frames == 120) then
					if not p.imune then
					p.vidas -=1
					end
					boat.res -= 0.1
					p.imune_frames -= 1
				end	
			end
			--remove setas
			if(seta.x > cam.x+128 or seta.x < cam.x)
			then
				del(proj, seta)
			end
			if(seta.y > cam.y + 128 or seta.y < cam.y)
			then
				del(proj, seta)
			end
		end
		rectfill(cam.x+5,cam.y+15,cam.x+30 - (1-boat.res)*25,cam.y+20, 4)

	--resources
	drawresourcebar2()

	--draw enemies
	palt(6, true)
	palt(0, false)

	if enemy_sprite_control % 10 == 0 
		or
				enemy_sprite_control % 11 == 0
		or
				enemy_sprite_control % 12 == 0
		then
		for i=1,30 do
			if outro then
				spr(2,i*8,13*8)
			else
				spr(39,i*8,13*8)
			end
		end
		
	end
	
	for v in all(e) do
		 
		enemy_sprite_control +=1
		if(enemy_sprite_control % 30 == 0)
		then
			spr_index +=  1
			enemy_sprite_control = 0
		end
		
		if spr_index > 25 then
			spr_index = 23
		end
	
		
		
		spr(spr_index,v[1],v[2])
		local dist = dist(p.x, v[1], p.y, v[2])
		go = true
		move = true
		if 19 < dist and dist < 20 then
		 move = false
	 end
		if dist < 20 then 
			go = false
	 end
	
		if move then 
			the_moves = goorrun(v[1],v[2],p.x,p.y,go) 
			v[1] = the_moves[1]
			v[2] = the_moves[2]
		end
	end
	palt(6, false)
	palt(0, true)
	movesetas()

end


function checkforcolision()

	dist_threshold = 3
	for fruta in all(ilha) do
		if dist(p.x, fruta.x, p.y, fruta.y)
					<= dist_threshold then
			del(ilha, fruta)
			boat.res += 0.5			
		end
	end
	
end

function drawsea()


camera(boat.x-64,boat.y-64)

for i=1,20 do
	for j=1,20 do
		spr(wavespr,
	 (flr(flr(boat.x)/8)-(9-j))*8,
		(flr(flr(boat.y)/8)-(9-i))*8)
	end
end

waveframe += 1

if(waveframe % 30 == 0) then
wavespr = 35
end



if(waveframe % 60 == 0) then
wavespr = 3
waveframe = 0
end

if(island_spawned) then
 spr(96,islandx,islandy)
 spr(97,islandx+8,islandy)
 spr(98,islandx+16,islandy)
 spr(99,islandx+24,islandy)
 spr(112,islandx,islandy+8)
 spr(113,islandx+8,islandy+8)
 spr(114,islandx+16,islandy+8)
 spr(115,islandx+24,islandy+8)
 spr(128,islandx,islandy+16)
 spr(129,islandx+8,islandy+16)
 spr(130,islandx+16,islandy+16)
 spr(131,islandx+24,islandy+16)
end

for v in all(enemylist) do
	spr(v[8],v[1], v[2])
	v[9] += 1
	if(v[9] % 20 == 0) then
		v[8] += 1
	end
	if(v[9] % 60 ==0) then
		v[8] = 55
		v[9] = 0
	end
end


if(boat.invulnerable == false) or
	(boat.frame%3 != 0) then
if lastmoved == 3 then
	spr(16,boat.x, boat.y,1,2,false,true)
elseif lastmoved == 2 then
	spr(16, boat.x, boat.y,1,2)
elseif lastmoved == 1 then
	spr(162, boat.x, boat.y,2,1)
elseif lastmoved == 0 then
 spr(162, boat.x, boat.y,2,1,true,false)		
end
end


end

score_counter = 60

function _update60()
	score_counter += 1
	if(score_counter % 5 == 0) then
		score+=1
		score_counter = 0
	end

	if(stage1) then
		--updatemainmenu()
	elseif(stage2) then
		if(trans2_3 == false) then
			updatesea()
		end
	elseif(stage3) then
		if(trans2_3 == false) then
			updateisland()
		end
	elseif(stage4) then
		--pausemenu()
	end
	
	
	if(boat.island) then
		trans2_3 = true
	end

	if(gameover) then
		trans2_4 = true
	end

	lives_frames += 1 
	if(lives_frames == 5) then
		lives_frames = 0
 
		if(p.vidas < #lives and #lives != 0) then
			local nr = lives[#lives]
   
			del(lives,nr)
   
			if(nr+1 <=90) then
				add(lives,nr+1) 
			end
   
		end
 
	end 

end
function simulatelives()
	if(fget(mget(p.x/8, p.y/8), 2))
then
		update_island = true
		
		
		p.imune = true
		p.voltarbarco = true
		boat.x = 0
		boat.y = 0
		boat.lastx = 0
		boat.lasty = 0
		island_spawned = false
		boat.island = false
  islandx =999
  islandy = 999

	end
end


function updateisland()


if(startisland) then
p.imune = true
	if(imunetemp > 120) then
 	p.imune = false
 	imunetemp = 0
 	startisland = false
		 
  
	end
	imunetemp +=1
end

simulatelives()



if(p.vidas == 0) then
	trans3_4 = true
	scorefin = score
end

if(p.voltarbarco) then
	trans3_2 = true
	p.voltarbarco = false
end
 
 --update player pos
 p.vx= 0 
 p.vy= 0 
	
	if(btn(2)) then
	 p.vy = -1
 end
	if(btn(3)) then 
		p.vy=1
	end
	if(btn(1)) then 
		p.vx=1
 end
	if(btn(0)) then 
		p.vx=-1
 end

-- colisoes x
	if not solid(p.x+p.vx,p.y) then
  p.x += p.vx
 end

 -- colisoes y
 if not solid(p.x,p.y+p.vy) then
  p.y += p.vy
 end

 
 --p.x += p.vx
 --p.y += p.vy

 
 if p.vy < 0 then
 	p.decostas = true
 	p.walking = false
 	p.right = false
 	p.idle = false
 end
 
 if p.vy == 0 and p.vx == 0 then
 	p.idle = true
 	p.walking = false
 	p.right = false
 	p.decostas = false
 end
 
 if p.vy > 0 or p.vx != 0 then
 	p.walking = true
 	p.right = false
 	p.decostas = false
 	p.idle = false
 end
 
 if p.vx > 0 then
 	p.walking = true
 	p.right = true
 	p.decostas = false
 	p.idle = false
 end
	
end

function updatesea()

if update_island then

	current_island += 1
		if current_island >2then
			current_island = 1
		end
		if(current_island == 1) then
			initialize_island_1()
		end
		if(current_island == 2) then
			initialize_island_2()
		end
		
		update_island = false
		if current_island == 1 then
   	p.x = 2*8
   	p.y = 12*8
   end
			if current_island == 2 then
   	p.x = 2*8
   	p.y = 26*8
   end
   
end

boat.collided = false

boat.distancex = boat.x-boat.lastx
boat.distancey = boat.y-boat.lasty

if(island_spawned == false) then

if(boat.distancex > distance_generate) then
--spawn island right
	islandx = boat.x + generate_offset
	islandy = boat.y + rnd(64)-32
	island_spawned = true 
elseif (boat.distancex < -distance_generate) then
--spawn island left
	islandx = boat.x - generate_offset
	islandy = boat.y + rnd(64)-32
	island_spawned = true
elseif (boat.distancey > distance_generate) then
--spawn island down
	islandy = boat.y + generate_offset
	islandx = boat.x + rnd(64)-32
	island_spawned = true
elseif (boat.distancey < -distance_generate) then
--spwn island up
	islandy = boat.y - generate_offset
	islandx = boat.x + rnd(64)-32
	island_spawned = true
end
else

if(boat.island == false) then

if (boat.x < islandx + 32 and
   boat.x + boat.width > islandx and
   boat.y < islandy + 24 and
   boat.height + boat.y > islandy) then
    boat.island = true
    
   
   end

end

if(boat.distancex > generate_reset)
or(boat.distancex < -generate_reset)
or(boat.distancey > generate_reset)
or(boat.distancey < -generate_reset)
 then
--remove island
island_spawned = false
boat.lastx = boat.x
boat.lasty = boat.y
end

end

boatmovement()


for v in all(enemylist) do
	if(boxcollision(boat,v))
	and(boat.invulnerable == false) then
			boat.collided = true
			boat.invulnerable = true
			boat.frame = 0
	end

	v[10] = boat.x - v[1]
	v[11] = boat.y - v[2]
	
	if(v[10] > refreshenemydist
	or v[10] < -refreshenemydist
	or v[11] > refreshenemydist
	or v[11] < -refreshenemydist)
	 then
	 if(randombool() == true) then
		 v[1] = boat.x + genenemydist +rnd(25) 
	 else
	  v[1] = boat.x - genenemydist-rnd(25) 
	 end
	 if(randombool() == true) then
		 v[2] = boat.y + genenemydist+rnd(25) 
	 else
	  v[2] = boat.y - genenemydist-rnd(25)
  end
	end
	
end

if boat.invulnerable then
boat.frame += 1
	if boat.frame == 50 then
		boat.invulnerable = false
	end
end

enemymovement()
updateres()
 if isgameover() then
 	transitionstate2_4()
 end

end

function randombool()
return (flr(rnd(2)) == 1)
end

function enemymovement()

for e in all(enemylist) do


	if(e[7] == 0) then
	local direction = randombool()
		if randombool() == true then

if(direction == true) then
				e[5] = 0.4
			else
				e[5] = -0.4
			end
			
			e[6] = 0

		else

		if(direction == true) then
				e[6] = 0.4
			else
				e[6] = -0.4
			end
			
			e[5] = 0

		end
	end
	
	if e[6] == 0 then
		e[1]+=e[5]
	elseif e[5] == 0 then
		e[2]+=e[6]
	end
	
	if e[7] == 40 then
		e[7] = 0
	else
		e[7] += 1
	end

if(e[1] < 0) then
	e[1] = 0
end

if(e[2] < 0) then
	e[2] = 0
end


end


end

function boxcollision(rect1, index)

if (rect1.x < index[1] + index[3] and
   rect1.x + rect1.width > index[1] and
   rect1.y < index[2] + index[4] and
   rect1.height + rect1.y > index[2]) then
 		 return true
end

return false

end

function boatmovement()
	if btn(4) then
		boat.boost = true
	else
		boat.boost = false
	end
-- boat x acceleration
    boat.ax = 0
    if (btn(0))then
     lastmoved = 0
     boat.ax=-.25
    end
    if (btn(1))then
     lastmoved = 1
     boat.ax=.25
    end
    -- apply x accel
    boat.vx += boat.ax

    -- limit x max speed
    if not boat.boost then
   	 if boat.vx > 1 then
       	 boat.vx = 1
   	 elseif boat.vx < -1 then
       	 boat.vx = -1
   	 end
   	else
   		if boat.vx > 2 then
       	 boat.vx = 2
   	 elseif boat.vx < -2 then
       	 boat.vx = -2
   	 end
   	end	

    -- drag
    if boat.ax == 0 then
        boat.vx *= 0.9
    end

    -- boat x acceleration
    boat.ay = 0
    if (btn(2))then
     lastmoved = 2
     boat.ay=-.25
    end
    if (btn(3))then
     lastmoved = 3
     boat.ay=.25
    end
 
    -- apply y accel
    boat.vy += boat.ay

    -- limit y max speed
   	if not boat.boost then
   	 if boat.vy > 1 then
    	    boat.vy = 1
   	 elseif boat.vy < -1 then
    	    boat.vy = -1
   	 end
   	elseif boat.boost then
   		if boat.vy > 2 then
    	    boat.vy = 2
   	 elseif boat.vy < -2 then
    	    boat.vy = -2
   	 end
				end
    -- drag
    if boat.ay == 0 then
        boat.vy *= 0.9
    end
        
boat.x += boat.vx
boat.y += boat.vy

end


function updateres()

	if(boat.ax != 0 or boat.ay != 0) then
		if(boat.boost) then
			boat.res -= 1/480
		else
			boat.res -= 1/1880
		end
	end
	
	if boat.collided then
		boat.res -= 0.1
	end
	
end

function isgameover()
	
	if boat.res <= 0 then
		gameover = true
		scorefin = score
		return true
	end
	
end

function wait(a) for i = 1,a do flip() end end

function drawmainmenu()
	map(65,1,8,8,14,14)
	camera(0,0)

	zspr(123,1,1,45,30,1.5) -- t
	zspr(121,1,1,52,30,1.5) -- r
	zspr(79,1,1,59,30,1.5) -- e
	zspr(75,1,1,66,30,1.5) -- a
	zspr(122,1,1,73,30,1.5) -- s
	zspr(124,1,1,80,30,1.5) -- u
	zspr(121,1,1,87,30,1.5) -- r
	zspr(79,1,1,94,30,1.5) -- e

	zspr(93,1,1,50,45,1.5) -- h
	zspr(124,1,1,57,45,1.5) --u
	zspr(108,1,1,64,45,1.5) --n
	zspr(123,1,1,71,45,1.5) --t
	zspr(79,1,1,78,45,1.5) --e
	zspr(121,1,1,85,45,1.5) --r
	if piscapisca % 60 == 0 then
		print("press z to start", 40,100,0,20)
		wait(60)
	end
	piscapisca+=1
	if(checkforstart()) then
		trans1_2 = true
	end
end

function checkforstart()
	if(btnp(4)) then
		return true
	end
end


function checkforstart()
	if(btnp(4)) then
		return true
	end
end

function zspr(n,w,h,dx,dy,dz)

  sx = 8 * (n % 16)

  sy = 8 * flr(n / 16)

  sw = 8 * w

  sh = 8 * h

  dw = sw * dz

  dh = sh * dz



  sspr(sx,sy,sw,sh, dx,dy,dw,dh)

end

function transitionstate2_3()
	counter += 1
	if counter % 15 == 0 then
		if stage2 == true then
			fader1 += 0.3
			fade_scr(fader1)
		elseif stage3 == true then
			fader2 -= 0.3
			fade_scr(fader2)
		end
	end
	
	if fader1 >= 1 then
		stage2 = false
		stage3 = true
		fader1 = 0
		fader2 = 1
		startisland = true
		imunetemp = 0
		p.imune = true
	end
	
	if fader2 <= 0 then
		trans2_3 = false
	end
	
	
end

function transitionstate3_4()
	counter3 += 1
	if counter3 % 15 == 0 then
		if stage3 == true then
			fader5 += 0.3
			fade_scr(fader5)
		elseif stage4 == true then
			fader6 -= 0.3
			fade_scr(fader6)
		end
	end
	
	if fader5 >= 1 then
		stage3 = false
		stage4 = true
		fader5 = 0
		fader6 = 1
	end
	
	if fader6 <= 0 then
		trans3_4 = false
	end
	
	
end

function transitionstate1_2()
	counter5 += 1
	if counter5 % 15 == 0 then
		if stage1 == true then
			fader9 += 0.3
			fade_scr(fader9)
		elseif stage2 == true then
			fader10 -= 0.3
			fade_scr(fader10)
		end
	end
	
	if fader9 >= 1 then
		stage1 = false
		stage2 = true
		fader9 = 0
		fader10 = 1
	end
	
	if fader10 <= 0 then
		trans1_2 = false
	end
	
	
end


function transitionstate3_2()
	counter4 += 1
	if counter4 % 15 == 0 then
		if stage3 == true then
			fader7 += 0.3
			fade_scr(fader7)
		elseif stage2 == true then
			fader8 -= 0.3
			fade_scr(fader8)
		end
	end
	
	if fader7 >= 1 then
		stage3 = false
		stage2 = true
		fader7 = 0
		fader8 = 1
	end
	
	if fader8 <= 0 then
		counter4 = 0
		fader7 = 0
		fader8 = 1
		trans3_2 = false
		trans2_3 = false
		p.imune = false
	end
	
	
end

function transitionstate2_4()
	counter2 += 1
	if counter2 % 15 == 0 then
		if stage2 == true then
			fader3 += 0.3
			fade_scr(fader3)
		elseif stage4 == true then
			fader4 -= 0.3
			fade_scr(fader4)
		end
	end
	
	if fader3 >= 0.8 then
		stage2 = false
		stage4 = true
		fader1 = 0
		fader2 = 1
	end
	
	if fader4 <= 0 then
		trans2_4 = false
	end
	
	
end

function fade_scr(fa)
	fa=max(min(1,fa),0)
	local fn=8
	local pn=15
	local fc=1/fn
	local fi=flr(fa/fc)+1
	local fades={
		{1,1,1,1,0,0,0,0},
		{2,2,2,1,1,0,0,0},
		{3,3,4,5,2,1,1,0},
		{4,4,2,2,1,1,1,0},
		{5,5,2,2,1,1,1,0},
		{6,6,13,5,2,1,1,0},
		{7,7,6,13,5,2,1,0},
		{8,8,9,4,5,2,1,0},
		{9,9,4,5,2,1,1,0},
		{10,15,9,4,5,2,1,0},
		{11,11,3,4,5,2,1,0},
		{12,12,13,5,5,2,1,0},
		{13,13,5,5,2,1,1,0},
		{14,9,9,4,5,2,1,0},
		{15,14,9,4,5,2,1,0}
	}
	
	for n=1,pn do
		pal(n,fades[n][fi],0)
	end
end

function dist(x1,x2,y1,y2)
	return sqrt((x1-x2)^2+(y1-y2)^2)
end

function goorrun(x1,y1,x2,y2,go)
	new_x =x1
	new_y =y1
	if(x1 < x2) then
		if go then new_x +=0.3
		else new_x -=0.3 end
	else
		if go then new_x -=0.3
		else new_x +=0.3 end
	end
	if(y1 < y2) then
		if go then new_y +=0.3
		else new_y -=0.3 end
	else
		 if go then new_y -=0.3
		else new_y +=0.3 end
	end
	return {new_x, new_y} 
end

function addproj(xi,yi,xd,yd)
 seta = {}
 seta.x = xi
 seta.y = yi
 seta.xd = xd
 seta.yd = yd
 angulo = atan2(yd-yi,xd-xi)
 seta.vx = sin(angulo)*1.5
 seta.vy = cos(angulo)*1.5
 add(proj, seta)
end

function movesetas()
	for seta in all(proj) do
		seta.x += seta.vx
		seta.y += seta.vy
	end
end

__gfx__
00000000cccc7cccffffffffccccccc73333333333333333fffff7ff65606650cccccccc0444444f0000000000020000300070d0000070000000000500000005
00000000cc7777ccffffffffccccccc733333333333333b3ffffffff66506650cccccccc004444f600020000030000d000000007000000000000055600050556
00000000c77ccc67ffffffffccccc7763433334333333333f7ffffff55506550cc7cc7cc00ffff66000370000000700020700000000000000000566600005666
0000000077ccccc6ffffffffccc776cc4444444434333333fffff7ff000000007c77cc7c00ffff660001ad000007000000000000700000000005057650000756
000000007cccccc6ff6f7fffcc776cccffff44f433333433ffffffff660666066776777700ffff66007c08000010a70000000007000000000000000505050005
00000000c77cc67cf776767fcc766cccff4fffff33333333fff7ffff650656066676657600ffff66000000000000700001070000000000070000055656505556
00000000cc7766cc77cc7c77c77cccccfffff5ff33b33333fffffff76505550555065505005555460000000000c0080000000908000000000000566676507666
00000000ccc6ccccccc6c7cc76ccccccf5ffffff333333337fffffff0000000000000000055555540000000000000000c0000000007000000005057666655566
00666600333333333333333367766776000440000066555044545444660000666600006666000066000771110007711100077111566656665666566600080000
76677667333338333b333333776776770888448806cc77c554445455607070066070700660707006077777700777777007777770056705670565056600088000
767007673b338a8333333533c776767c87888888066ccc65455445446080080660800806608008060f1f1ff00f1f1ff00f1f1ff00565056505670565008a9800
670000763333383333333333cc6c7ccc88788888066666655444544566000066660000666600006000effe0000effe0000effe0000500050005005750089a980
700440073333333333343333cccccccc8878888806666665445445440660066666600660666006600f9999f0009999f00f9999000005000505005005089aa980
004444003b33333343333333cccccccc088888880566665545454445610220166102201661022016009999000f999900009999f0000000000000055600899800
00464400b33333b333333333cccccccc008888800556655554445544666226600662266660622666000440000004400000044000000000000000566600488400
006754003333333333333333cccccccc00000000005555504545445465565566665655666656655601f01f00001ff10000f1f100000000000005057600044000
067754003bbbbb4333333333ccc7cccc004444000000000000000000ffffffff6600006666000066000771110007711100077111675050006655566600008000
00664400bbb8bbb433333333ccc7cccc005555000000000000000000ffffffff6000000660000006077777700777777007777770666500006667056700088000
00444400b83333bb33333333c776cccc056eee500004000000022000ffffffff600000066000000607777770077777700777777065500000655505650089a800
00044000b33333333333333376ccccc7057eee50008648000007e000ffffffff660000666600006000f77f0000f77f0000f77f005000000050005050008a9980
0700007033338333333333336ccccc7705e7ee50008888000007e000ff6f7fff66600660666006600f9999f0009999f00f9999006750500065700005089aa980
0670076033333333333333336ccccc7605eeee5000088000000ee000f776767f6000000660000006009999000f999900009999f0666500006665000000899800
066776604333333333333333ccccc77c05eeee50000000000000000077c776c70664466660644666000440000004400000044000655000006550500000488400
000000003333333333333333cccc76cc005555000000000000000000cc7ccc76660600066606600601f01f00001ff10000f1f100500000005000000000044000
00000000000771110000000000000000155555563333333356666667000000000000000000000000000220000002200000022000000000006750500000080000
00077111077777700007711105500000015555673355553356777776033303330333033303330333002e2200002e2200002e2200000000006665000000088000
077777700f1f1ff0077777700000000000666677354777535677777700a303a00a39093a0a39393a02ee2e2002ee2e2002ee2e20000000006550000000889800
0f1f1ff000effe000f1f1ff00000055000666677354447535677777700393930003333308077777002ee2e2002ee2e2002ee2e2050005000500500500089a980
00effe000f9999f000effe00000000000066667735444753567777778033333080377730883777302ee2eee22eee2ee22eeee2e20500050057500500089aa980
0f9999f0009999000f9999f0055000000066667735444453567777778003330088033300880333002e6e6ee22e6e6ee22e6e6ee256505650565076500089a800
00099000000440000009900000000000011111573355553357666666303aaa30303aaa30033aaa3002eeee2002eeee2002eeee20765076506650565000488400
01f01f0001f01f0001f01f000000055011111115333333336555555533aaaaa333aaaaa333aaaa30202222002022220200222202666566656665666500044000
ffffffffcccccccccccccccccccccccc044444400099990000099000000990000099990050505050333533350077770000777000000777000077700000777700
ffffffffcccccccccccccccccccccccc49aaaa9409a00090009a09000090a90009000a9035353535333353500075575000755700007055500075570000755550
ffffffffcccccccccccccccccccccccc4999999409a00090009a09000090a90009000a9033333333333533350075075000750750007500000075075000750000
ffffffffcccccccccccccccccccccccc94477449097aaa900097a900009a790009aaa79035353535333353500077775000777050007500000075075000777000
f6f7ffffcccccccccccccccccccccccc9aa55aa90099990000090000000090000099990053535353333533350075575000755700007500000075075000755500
776767ffcccccccccccccccccccccccc9aaaaaa90009a0000009a000000a9000000a900033333333333353500075075000750750007500000075075000750000
77677677cccccccccccccccccccccccc9aaaaaa90009000000090000000090000000900033333333333533350075075000777050000777000077705000777700
67766776cccccccccccccccccccccccc999999990009a0000009a000000a9000000a900033333333333353500005005000055500000055500005550000055550
cccccccccccc76500000000005667ccc044774400000000000000000000000000000000000000000000000000077770000077700007007000077770000777700
ccccccccccc77700505560550567cccc499999940870088008700880087000800870008008000000000000000075555000705500007507500007555000055750
cc7cc7cccc7c755067566766007777cc49aaaa948787888887870888878708888787008887000008800000080075000000750000007507500007500000000750
7c77cc7ccccc76507777677606667ccc944444498788888887888888870008888700088887000088000000000077700000757700007777500007500000700750
67767777ccc76660c7cc77c70567cccc9aa55aa90878888008708880087088800870088008700080080000800075550000750750007557500007500000750750
66766576cc777700cc7cc7cc0557c7cc9aaaaaa90087880000878800008788000080080000800800000008000075000000750750007507500007500000750750
55065505cccc7650cccccccc00777ccc9aaaaaa90008800000008000000880000000800000000000000000000075000000077050007507500077770000077750
00000000ccc76650cccccccc0567cccc999999990000000000000000000000000000000000000000000000000005000000005500000500500005555000005550
cccccccccc3333cccc3333cccccccccc007777000000070000777700007777000070070000700700007000000077770000700700007777000077770000077000
ccccccc3333333333333333ccccccccc007557500000075000055750000557500075075000750750007500000077775000770750007557500075575000705700
cccc3333333333333333333ccccccccc007507500000075000000750000007500075075000757050007500000075575000757750007507500075075000750750
ccc33333335533333333333ccccccccc007507500000075000777750007777500077775000770500007500000075075000757750007507500077775000750750
cc33333335553333333333333ccccccc007507500000075000755550000557500005575000757000007500000075075000755750007507500075555000750750
cc3333333c5333333333333333cccccc007507500000075000750000000007500000075000750700007500000075075000750750007507500075000000757050
533333337c55333333333333333ccccc007777500000075000777700007777500000075000750750007777000075075000750750007777500075000000070700
553355337c553333333333333b3ccccc000555500000005000055550000555500000005000050050000555500005005000050550000555500005000000005050
f5b55533cc5553b33b3333b33b3ccccc007777000077770000777700007777000077770000777000000777000077770000700700007007000070070000700700
f5b35553c73b53b33bbb33b333b3cccc007555500075555000055750007557500075575000755700007055500007555000750750007507500075075000750750
f5bb33577b3bb33bb3b3bb3bbb3333cc007500000075000000000750007507500075075000750750007500000007500000750750007507500075075000750750
ff5bb3333bb3b5333b3bbb33bbbbbb3c007777000077770000000750007777500077775000777050000770000007500000750750007507500075075000077050
cff53bb3b3b3555533bb3bbb3bbb3b35000557500075575000000750007557500005575000755700000057000007500000750750007507500077075000705700
ccff53b3bb33555bb3b33b33bbbbb555000007500075075000000750007507500000075000750750000007500007500000750750007570500075775000750750
cccff53b333b3bb333bb33b33355555f007777500077775000000750007777500000075000750750007770500007500000077050000705000075075000750750
ccccfff5535bb3bbbbbbbbb55555555f000555500005555000000050000555500000005000050050000555000000500000005500000050000005005000050050
ccccccfff55555555555555555555fff000000000007000000000000000000000700000000000000007788000088800000000000004444404444777704444400
ccccccccfffffffff555555555ffffcc000007000076600000000000000700000000000000000000088887800877880000778800004444444444444744444400
cccccccccccffffffff5555ffffffccc000006700766660000000700000000700000700070000000778888870788878007888780444444444444444744444444
cccccccccccccccccfffffffffcccccc999956670005000000000007000070000070000000000000888778887887788778877887444444444444444744444444
cccccccccccccccccccccccccccccccc000006600009000000000700000000700000000000700000078888700788887007888870444444474444444474444444
cccccccccccccccccccccccccccccccc0000060000090000000000000007000000700000000000000081f1000881f1800881f180444444474444444474444444
cccccccccccccccccccccccccccccccc000000000009000000000000000000007000000000000000000ff000000ff000000ff000444444470044444474444444
cccccccccccccccccccccccccccccccc00000000000900000000000000000000000000007000000000ffff0000ffff0000ffff00044477770044444477774440
0070070000777700ccc77750000000000000000005667ccc34444443055555500000000055555555566666656555555677774440ffffffffffffffff444477ff
0075075000055750cccc765055565500005560550567cccc44999944556666550000000055666655665555665577775574444444fffffffffffff4ff444477ff
0075075000007050cc7cc7507676655005566766007777cc499ff9945667766500000000566556656557755657777775744444447777777777774777444477ff
00077050000705007c77c66077cc76500567677606667cc749f77f945677776500000000565775656577775657777775744444447777777777747777444477ff
0007550000705000677676507cc76660066c77c70567cc7749f77f945677776500000000565775656577775657777775444444444444444444444444444477ff
000750000075000066766550cc777700057cc7cc05566767499ff9945667766500000000566556656557755657777775444444444444444444444444444477ff
000750000077770055065500cccc76500567cccc00556555449999445566665500000000556666556655556655777755444444004444444444400044444477ff
000050000005555000000000ccc7665005777ccc00000000344444430555555000000000555555555666666565555556044444004444444444000004444477ff
ffffffffffffffff006600000007677044000004ff774444ff774444ffffffff8fffff88ffffffffffffffffffffffffffffffff000000000000000000000000
ffffff5555ffffff666700060000766044400044ff774444ff774440ffffffff88fff88ffffffffff8ffffffffffffffffffff8f000000000000000000000000
fff5555665555fff667004676440076644444444ff774444f4774400fffffffff88f88fffffff88f88ffffffffffffffffffff88000000000000000000000000
ff556666666655ff670044677644007644444444ff774444ff474400ffffffffff888fffffff88ff88ffffffffffffffffffff88000000000000000000000000
ff566ffffff655ff670044455444007677777477ff774444ff744400fffffffffff888fffff88fff88ffffffffffffffffffff88000000000000000000000000
ff56fff86ff665ff667004444440076677774777ff774444ff774440ffffffffff88f88fff88ffff88ffffffffffffffffffff88000000000000000000000000
f556fff88fff655f6667000000007660fff4ffffff774444ff774444fffffffff88fff88f88fffff8ffffffff88888fffffffff8000000000000000000000000
f566ff8888ff665f0066000000076770ffffffffff774444ff774444ffffffff88fffff8ffffffffffffffffff88888fffffffff565656565656565656560000
f566fff88fff665f444477ff44444444000000000000000000000000000000000000000000000000000000000000000000000000656565656565656565650000
f556ffffffff655f444477ff44444444000000000000000000000000000000000000000000000000000000000000000000000000560000000000000000560000
f5566ffffff665ff044447ff44444444000000000000000000000000000000000000000000000000000000000000000000000000650000000000000000650000
ff556ffffff655ff004474ff44444444000000000000000000000000000000000000000000000000000000000000000000000000560000000000000000560000
ff556666666655ff004477ff77777777000000000000000000000000000000000000000000000000000000000000000000000000650000000000000000650000
fff5555665555fff004477ff77777777000000000000000000000000000000000000000000000000000000000000000000000000560000000000000000560000
ffffff5555ffffff044477ffffffffff000000000000000000000000000000000000000000000000000000000000000000000000656565656565656565650000
ffffffffffffffff444477ffffffffff000000000000000000000000000000000000000000000000000000000000000000000000565656565656565656560000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888228228888228822888222822888888822888888ff8888
88888888888888888888888888888888888888888888888888888888888888888888888888888888882288822888222222888222822888882282888888fff888
88888888888888888888888888888888888888888888888888888888888888888888888888888888882288822888282282888222888888228882888888f88888
888888888888888888888888888888888888888888888888888888888888888888888888888888888822888228882222228888882228882288828888fff88888
88888888888888888888888888888888888888888888888888888888888888888888888888888888882288822888822228888228222888882282888ffff88888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888228228888828828888228222888888822888fff888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555b585d5a5555c595e5b555585d5a5f5555c5d5e505555c5d5e50555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555556666666665566666666655666666666556666666665577777777755555555555555555555555555555555555
555566656665666566656665666566555555e55565556555655655565656556555655565565556566655755575557555e555555555d555555555555555555555
55556565656556555655655565656565555ee55565656665655656565656556565656665565656566655757577757555ee55555555dd55555c55c55511115555
5555666566655655565566556655656555eee55565656655655656565556556565655565565656555655757577757555eee5555ddddd1555cc55c55511115555
55556555656556555655655565656565555ee55565656665655656566656556565666565565656565655757577757555ee55555d00d1715cccccc55511115555
555565556565565556556665656565655555e55565556555655655566656556555655565565556555655755577757555e555555d55d17710cc00055511115555
55555555555555555555555555555555555555556666666665566666666655666666666556666666665577777777755555555550550177710c55555500005555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555177771055555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555177115555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555511715555555555555555
55555555555500000000055555555555555555555550000000005555555555555555555555000000000555555555555555555555555555555555555555555555
55555666665506660666055555555555555566666550666066605555555555555556666655066606660555555555555555666665555555555555555555555555
55555655565500060606055555555555555565556550006060605555555555555556555655000606060555555555555555655565555555555555555555555555
55555657565506660666055555555555555565756550666066605555555555555556575655006606060555555555555555655565555555555555555555555555
55555655565506000606055555555555555565556550600000605555555555555556555655000606060555555555555555655565555555555555555555555555
55555666665506660666055555555555555566666550666000605555555555555556666655066606660555555555555555666665555555555555555555555555
55555555555500000000055555555555555555555550000000005555555555555555555555000000000555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507770000066600eee00ccc00ddd00550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550707000000060000e0000c0000d00550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd00550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550707000006000000e00c0000d0000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550707000006660000e00ccc00ddd00550010001000100001000010000100055001000100010000100001000010005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507770000066600eee00ccc00ddd0055000000000000000000000000000005507700000066000eee00c0c00000005505555555555555555555555555550555
5550700000000060000e0000c0000d0055000000000000000000000000000005507070000006000e0e00c0c00000005505555555555555555555555555550555
5550770000000660000e00ccc00ddd0055000000000000000000000000000005507070000006000e0e00ccc00000005505555555555555555555555555550555
5550700000000060000e00c0000d000055000000000000000000000000000005507070000006000e0e0000c00000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd0055001000100010000100001000010005507770000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507770000066600eee00ccc00ddd005500770000066000eee00c0c00ddd005507700000066000eee00c0c00000005505555555555555555555555555550555
5550700000000060000e0000c0000d005507000000006000e0e00c0c0000d005507070000006000e0e00c0c00000005505555555555555555555555555550555
5550770000000660000e00ccc00ddd005507000000006000e0e00ccc000dd005507070000006000e0e00ccc00000005505555555555555555555555555550555
5550700000000060000e00c0000d00005507000000006000e0e0000c0000d005507070000006000e0e0000c00000005505555555555555555555555555550555
5550700000006660000e00ccc00ddd005500770000066600eee0000c00ddd005507770000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507770000066600eee00ccc00ddd00550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550700000000060000e0000c0000d00550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550770000000660000e00ccc00ddd00550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550700000000060000e00c0000d0000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd00550010001000100001000010000100055001000100010000100001000010005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507700000066600eee00ccc00ddd005500770000066000eee00c0c00ddd005507770000066000eee00c0c00000005505555555555555555555555555550555
5550707000000060000e0000c0000d005507000000006000e0e00c0c0000d005507000000006000e0e00c0c00000005505555555555555555555555555550555
5550707000000660000e00ccc00ddd005507000000006000e0e00ccc000dd005507700000006000e0e00ccc00000005505555555555555555555555555550555
5550707000000060000e00c0000d00005507000000006000e0e0000c0000d005507000000006000e0e0000c00000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd005500770000066600eee0000c00ddd005507000000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
5550000000000000000000000000000055000000000000000000000000000005507770000066000eee00c0c00000005505555555555555555555555555550555
5550000000000000000000000000000055000000000000000000000000000005507000000006000e0e00c0c00000005505555555555555555555555555550555
5550000000000000000000000000000055000000000000000000000000000005507700000006000e0e00ccc00000005505555555555555555555555555550555
5550000000000000000000000000000055000000000000000000000000000005507000000006000e0e0000c00000005505555555555555555555555555550555
5550010001000100001000010000100055001000100010000100001000010005507000000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507770000066600eee00ccc00ddd0055000000000000000000000000000005507770000066000eee00c0c00000005505555555555555555555555555550555
5550707000000060000e0000c0000d0055000000000000000000000000000005507000000006000e0e00c0c00000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd0055000000000000000000000000000005507700000006000e0e00ccc00000005505555555555555555555555555550555
5550707000006000000e00c0000d000055000000000000000000000000000005507000000006000e0e0000c00000005505555555555555555555555555550555
5550707000006660000e00ccc00ddd0055001000100010000100001000010005507770000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507770000066600eee00ccc00ddd0055000000000000000000000000000005500770000066000eee00c0c00000005505555555555555555555555555550555
5550707000000060000e0000c0000d0055000000000000000000000000000005507000000006000e0e00c0c00000005505555555555555555555555555550555
5550770000006660000e00ccc00ddd0055000000000000000000000000000005507000000006000e0e00ccc00000005505555555555555555555555555550555
5550707000006000000e00c0000d000055000000000000000000000000000005507070000006000e0e0000c00000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd0055001000100010000100001000010005507770000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55505050505050505050505050505050550505050505050505050505050505055050505050505050505050505050505505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507700000066600eee00ccc00ddd005500770000066000eee00c0c00ddd005500770000066000eee00c0c00000005505555555555555555555555555550555
5550707000000060000e0000c0000d005507000000006000e0e00c0c0000d005507000000006000e0e00c0c00000005505555555555555555555555555550555
5550707000000660000e00ccc00ddd005507000000006000e0e00ccc000dd005507000000006000e0e00ccc00000005505555555555555555555555555550555
5550707000000060000e00c0000d00005507000000006000e0e0000c0000d005507070000006000e0e0000c00000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd005500770000066600eee0000c00ddd005507770000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500770000066600eee00ccc00ddd005500770000066000eee00c0c00ddd005507700707066000eee00c0c00000005505555555555555555555555555550555
5550700000000060000e0000c0000d005507000000006000e0e00c0c0000d005507070777006000e0e00c0c00000005505555555555555555555555555550555
5550700000000660000e00ccc00ddd005507000000006000e0e00ccc000dd005507070707006000e0e00ccc00000005505555555555555555555555555550555
5550700000000060000e00c0000d00005507000000006000e0e0000c0000d005507070777006000e0e0000c00000005505555555555555555555555555550555
5550077000006660000e00ccc00ddd005500770000066600eee0000c00ddd005507770707066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005505555555555555555555555555550555
55507770000066600eee00ccc00ddd0055000000000000000000000000000005507770000066000eee00c0c00000005505555555555555555555555555550555
5550707000000060000e0000c0000d0055000000000000000000000000000005507070000006000e0e00c0c00000005505555555555555555555555555550555
5550770000006660000e00ccc00ddd0055000000000000000000000000000005507770000006000e0e00ccc00000005505555555555555555555555555550555
5550707000006000000e00c0000d000055000000000000000000000000000005507070000006000e0e0000c00000005505555555555555555555555555550555
5550777000006660000e00ccc00ddd0055001000100010000100001000010005507070000066600eee0000c000d0005505555555555555555555555555550555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000200080003000200000000020205000000000000010101020202020202040200020000000001010202020202020202020000000200000000000002020200000000000000000002000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000002020000000000000000000005050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2121212121212121212121212121212121212121212121212121212121212121030336360707070707070707070707070707070707070707070707070707070700000000000000000000000000000000000000000000000000ededededededededededededededededededededededededededededededededededededededed
210909090909090909090909090909090909090909090909090909090909092103030606072e3344331e072e1d1d1d1d1e072e1d1d1d1d1f0797974497979707008da4b3b3b3a4b3b3a4b3b3b3a48f00000000000000000000ededededededededededededededededededededededededededededededededededededededed
2109169716971609111111111111110916161616161616161697161616970921030306060733339b333333333333333333073333333333330e16161616169707009fa7a7a7a7a7a7a7a7a7a7a7a7a600000000000000000000ededededededededededededededededededededededededededededededededededededededed
21091616161616090909090909090909161616161616161616161616161609210303060607333333333333333333333333073333333333330e1616161616970700b2a7a0a1a7a7a7a7a7a7a7a7a7a500000000000000000000ededed00ededededededededededededededededededededededededededededededededededed
210916090909160916169716971616091616160916160909091616161616092103030606073e3333330f2e333333333333073333330f07070707070707070707b4b2a7b0b1a7a7a7a7a7a7a7a7a7a6b4000000000000000000ededed0000edededededededededededededededededededededededededededededededededed
2109160921091609161616161616160916161609161609210916161616160921030306061e070707072e1f33331f3d333d07333333072e1f1e97979744979707b4b2a7a7a7a7a7a7a7a7a7a7a7a7a5b4ededededededededededededed000000ed000000edededededededededededededededededededededededededededed
2109160909091609161609090916160916161609161609210997161616970921030306061f1d1d1d1d3333333307333333073333330733330e16971616161607b4b2a7a7a7a7a7a7a7a7a7a7a7a7a5b4edededededededededededed0000ed00edededed0000000000ededededededededededededededededededededededed
2109161616161616161609210916161616161609161609090909091609090921a2a3060633333333333333333307333333073333330733330e16979797971607b49fa7a7a7a7aba7a7a7a9a7a7a7a6b4edededededededededededededed00ededededededededededededededededededededededededededededededededed
2109161616161616161609090916161616161609161616160916161616160921030306061f3d3d3d3d333333330733339b0733333307331f0f16161616161607b49fa7a7a7aca7aaa7a9a7a7a7a7a5b4edededededededededededededed00ededededededededededededededededededededededededededededededededed
2109160909090909091616161616090916161609090916160916161616160921030306060f070707073e1f33331f0707331f33333307330e0707070716070707b4b2a7a7a7a7a9aba9a7a7a7a7a7a5b4edededededededededededededed00ededededededededededededededededededededededededededededededededed
210916160921210911091616160911091616160921091616091696169616092103030606072e3344331e3e3333331e072e3333333307331f1e16161616161607b4b2a7a7a7a9a7a7a7a7a7a7a7a7a5b400ed0000000000000000000000ededededededededededededededededededededededededededededededededededed
21090909090404090409090909090409161616090409090909090909090909210303060607333333333333333333331d9b333333331d33330e16161616161607b49fa7a7a9a7a7a7a7a7a7a7a7a7a6b4000000000000000000000000edededededededededededededededededededededededededededededededededededed
21060606060606060606060606060606060606060606060606060606060606210303060607333333333333333333333333333333333333330e16161616161607b49fa7a8a7a7a7a7a7a7a7a7a7a7a5b400000000000000000000000000edededed00edededededededededededededededededededededededededededededed
210202020202020202020202020202020202020202020202020202020202022103030606073e3333330f073e33333333333333333333331f0f16161616161607b4b2a7a7a7a7a7a7a7a7a7a7a7a7a5b4000000000000000000000000edededed000000000000edededededededededededededededededededededededededed
0310030303030303030303030303030303030303030303030303030303030303030306061e070707070707070707070707070707070707070707070707070707b48e9d9e9d9e9d9d9d9d9e9d9e9d9cb400000000000000000000000000edededed000000000000ededededededededededededededededededededededededed
0320030303030303030303030303030303030303030303030303030303030303030306061f072e1d1d1d1e07072e1f1d1d1d1d1e072122222222222221222107000000000000000000000000000000000000000000000000000000edededededededededededededededededededededededededededededededed0000000000
2121212121212121212121212121212121212121212121212121212121212121030306060f0797333333331d1d3333333333330e072212222222122221222207000000000000000000000000000000000000000000000000000000edededededededededededededededededededededededededededededededed0000000000
2111161616161616161616161112051105051105051205050707070505050521030306060707443333333333333333333333330e0722228a22222222211122070000000000000000ed0000edededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116161616160707161616161611051105051211050505050712121105110521030306061e07973333333333333333333333330e07222222122222222222220700eded00ed000000000000edededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116161616160707161616161616110505110512050511050705120505050521030306061f2e33333333333d3d3d3d333333330e07212222972222972222440700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116160916161616161616161611070707070707070505050705050507050521030306061d33333333330e070707072d3333330e070707071f33331f0707070700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116160909090909161609090911030303030303070505050707070707050521a2a306063333333333330e070707072d3333330e072e1d1d333333331d1d1e0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116161616161609161607070911030303030303070505120505121105050521030306063d3d3d3d3d3d0f070707072d3333330e073333333338333333330e0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2109090909161609161607070911111111111111050511050505120505110521030306061e07072e1d1d1d1d1d1d1d333333331f073333333333333333330e0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116161609090909161616161605050509090909050512090909090909050521030306061f072e333333971f33331f973333330e33333333333333332d330e0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116161616161616161616161609090909050505110505050512050505050521030306060f07333333333333333333333333330e33333333333333972d330e0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2116160909090916160909090909050505051105050909090909090909090921030306060707449b33333333333333333333331f072e1d1d1d1d1d1d33330e0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2104040404040404040404040404040404040404040404040404040404040421030306061e07333333333333333333333333330e074433333333333333330e0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2106060606060606060606060606060606060606060606060606060606060621030306061f073e3d3d3d971f3d3d1f973d3d3d0f073e3d3d3d3d3d3d3d3d1f0700edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
2102020202020202020202020202020202020202020202020202020202020221030336360f070707070707070707070707070707070707070707070707070707ededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
030310030303030303030303030303030303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000edededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed00
030320030303030303030303030303030303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000ededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededededed
__sfx__
010100001261013610126101205000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012800001f6201f6201f6200c6100c6100c6100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00101b05000000000001b05000000000001e05000000200500000021050000002005000000210500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00101b05300000000001b05300000000001e05300000200530000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000024623000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000024051000003000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c000021142211422414224142201422014223142231421f1421f14222142221421d1421d1421d1421d14200000000000000000000000000000000000000000000000000000000000000000000000000000000
000c000021030210302103021030200302003020030200301f0301f0301f0301f0301d0301d0301d0301d03000000000000000000000000000000000000000000000000000000000000000000000000000000000
0114000015520185301a550000001a550000001a5501c5501d550000001d550000001d5501f5501c550000001c550000001a55018550185501a550000000000015550185501a550000001a550000001a5501c550
011400001d550000001d550000001d5501f5501c550000001c550000001a550185501a55000000000000000015550185501a550000001a550000001a5501d5501f550000001f550000001f550215502255000000
011400002255000000215501f550215501a55000000000001a5501c5501d550000001d550000001f55000000215501a55000000000001a5501d5501c550000001c550000001d5501a5501c550000000000000000
0114000015550185501c550000001c550000001a550195501a550000001a550000001c550000001d550000001d5501d5501f55000000215502155021550215501d5501a550155501555015550000000000000000
01140000225502255022550225501d5501a550175501755017550000001a5501c5501d550000001d550000001f55000000215501a550000001a5501d5501c550000001c550000001d5401c5301a5201a52000000
0114000000000000001155000000115500000015550185501a550000001a550000001a5501c550185500000018550000001655015550115501155000000000000000000000165500000016550000001655018550
011400001555000000155500000015550165501355000000135500000011550105501155000000000000000000000000001155011550115501155011550115501a5501a5501a5501a5501a5501a5501a5501a550
011400001a5501a5501a5501a5501155011550115501155011550115501a5501a5501a5501a5501a5501a550115501155011550115501155011550195500000019550000001a5501755019550000000000000000
011400000000000000195500000019550000001655015550115500000011550000001355000000155500000015550155501655000000115501155011550115501555011550105501055010550000000000000000
011400001355013550135501355017550115500e5500e5500e5500000000000000001a5501a5501a5501a5501a5501a550115501155011550115501155011550000001955000000195401a5301a5201a52000000
0114000000000000000e5500e5500e5500e5500e5500e5501655016550165501655016550165501555015550155501555015550155500e5500e5500e5500e5500e5500e550115501155011550115501155011550
011400000c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5501655016550165501655016550165501355013550
01140000135501355013550135500e5500e5500e5500e5500e5500e5501655016550165501655016550165500e5500e5500e5500e5500e5500e55015550155501555015550155501555015555155551555515550
0114000015550155501555015550155501555011550105500e550000000e550000000d550000000c550000000c5500c5500e550000000e5500e5500e5500e5500e5500e5500d5500d5500d5500c5500c5500c550
011400000e5500e5500e5500e5500e5500e5501355013550135100000000000000001655016550165501655016550165500e5500e5500e5500e5500e5500e5501355013550135501354013530135201352000000
0114000000000000000c0730c07324615000000c073000000c0730c07324615000000c073000000c0730c07324615000000c073000000c0730c07324615000000c07300000100730c07324615000000c07300000
01140000100730c07324615000000c07300000100730c07324615000000c07300000100730c07324615000000c07300000100730c07324615000000c07300000100730c07324615000000c073000002461500000
001400001007300000246150000010073100730000000000000000000010073246152461500000000002460010073246152461500000000000000010073100731007300000100731007310073246152461500000
001400000000000000000000000000000000000000000000100731000010073100001007310000100731000010073000000000010000100730000000000100731007310073000000000000000000000000000000
001400001007300000000000000010073100731007300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011900202172228722297222872226722000032172223722267222472223722000002172223722297222872226722247222472200000217222372224722267222872224722000002872226722247222172200000
0119002000000000000c043000000c0432460024600000000c0430c0432460000000000000c043246000c04324600000000c0432460000000000000c0430c043246000c04324600000000c0430c0430c04324600
01190020000000e0400e0400000011040110401004013040130400f04015040000000f040000001004013040130400f04013040150401504013040110400e040000001604015040100400e0400c0400e0400e040
010f00001f05022050000002605000000240500000024050000002205022050220502205022050000001f0501f05000000000001f050220500000026050000002405000000240500000022050220502205022050
010f000022050000001f0500000000000000001f05022050000002605000000240500000024050000002205022050220502205022050000001b0501b0501b0500000022050220502205022000210502105021050
010f0000000001d0501d0501d05000000000000000000000000001f0502205000000260500000029050000002b05000000290502905029050290502905000000260500000000000000001f050220500000026050
010f00000000026050000002405000000240500000022050220502205022050220500000026050000002705000000260500000000000180502205022050220502205022050000002905029050000002605026050
010f00002605026050260502604026030260202601026000000000000000000000001f050000002b050000002b050000002b050000002b050000002b050000002b0502b0502b050000002a0502a0502a05000000
010f0000000002a0502a0502a050000002b0502b0502b050000002d0502d0502d050000002e0502e0502e050000002e050000002e0502e0502e050000002e050000002e0502e0502e050000002d0502d0502d050
010f00000705007050000000705000000070500000005050000000505005050050500505005050000000705000000070500000007050070500000007050000000705000000050500000005050050500505005050
010f00000505000000050500000005050000000705007050000000705000000070500000005050000000505005050050500505005050000000705007050070500000007050070500705000000090500905009050
010f00000000009050090500905000000070500000007050000000705007050000000705000000070500000005050000000505005050050500505005050000000705000000070500000007050070500000007050
000f00000000007050000000705000000050500000005050050500505005050050500000007050000000705000000070500705000000070500000009050090500000009050000000505005050000000705007050
000f000007050000000705000000070500000005050050500505000000050500505005050000001b0501b0501b050000001b050000001b050000001b0501b0501b050000001b0501b0501b050000001b05000000
000f0000000001a0501a0501a050000001a050000001a0501a0501a050000001a0501a0501a050000001b0501b0501b050000001b0501b0501b050000001b050000001b050000001b05000000200502005000000
0108000000000000001a0501a0501a0501a0501a05000000000001805018050000000000016050160500000000000130501305013050130501305000000000000000000000000000000000000000000000000000
011000000c000246000c073246150c000246000c00024615246000000000000000000c07324615000000000000000000000c0000c000000000c073246150000000000000000c0732461500000000000000000000
000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 080d1217
00 090e1318
00 0a0f1419
00 0b10151a
02 0c11161b
00 484d5257
01 1c1d1e44
02 1c1d1e44
01 1f256c44
00 20266d44
00 21274344
00 22284344
00 23294344
00 242a4344
02 2b6c4344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

