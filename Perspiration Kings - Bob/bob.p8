pico-8 cartridge // http://www.pico-8.com
version 14
__lua__
-- bob
-- made by perspiration kings

function _init()
  cls()
  
  col = 1
  
  camx = 0
  camy = 0
  palt(14, true)
  palt(0, false)

  anim_time = 0
  
  game = {}
  game.state_mode = 0
  game.text = "nothing"
  game.floor = 1

  color(1)
  anim_time_intro = 0
  initscreen_draw()
  titleinit()
  title_update()
  cls()
  
  display_title_text()

  player = {x=75,
  y=100,
  width=4,
  height=4,
  direction = 2,
  x_acc = 0,
  y_acc = 0,
  task=0,
  currentclue=1}

  fade_index = 0
  fading_out = false
  fading_in = false

  was_pressed = false
  previousposx = player.x
  previousposy = player.y

  time_counter = 0
  seconds = 0
  minutes = 5
    
  all_sprites = {}

  x_increment = 0
  y_increment = 0

  for i = 0, 128 do
    for j = 0, 128 do 
      sprite_num = mget(i,j)
      if fget(sprite_num, 0) then
        new_sprite = {x = i*8,y = j*8,id = sprite_num}
        add(all_sprites, new_sprite)
      end  
    end
  end 

  init_animations()
  collided = false

  objects_array = {}
  fillobjectarray()
  cls()
  titleinit()
  music(40)
  first_dialogue()
  gameinit()
end


function detect(sprite_to_analyze)
  if ((player.x - player.width < sprite_to_analyze.x - 4 and player.x + player.width > sprite_to_analyze.x-4) or
    ((player.x - player.width > sprite_to_analyze.x-4) and (player.x + player.width < sprite_to_analyze.x + 4)) or
    (player.x - player.width < sprite_to_analyze.x+4) and (player.x + player.width > sprite_to_analyze.x + 4)) then
  if ((player.y + player.height > sprite_to_analyze.y+4 and player.y - player.height < sprite_to_analyze.y+4) or 
    (player.y + player.height < sprite_to_analyze.y+4 and player.y - player.height > sprite_to_analyze.y-4) or
    (player.y + player.height > sprite_to_analyze.y-4 and player.y - player.height < sprite_to_analyze.y-4)) then
  return true
end
end
return false
end

function move()

  local flag = 0
  if(not(read_key())) then
    player.y_acc /= 1.7
    player.x_acc /= 1.7
    flag = 1
  end

  player.x += player.x_acc
  player.y -= player.y_acc
  if(flag == 1 ) then 
    return false
    else return true 
  end

end

function read_key()

  local press = false

  if btn(0) then
    player.direction = 0
    player.x_acc = -2.5
    player.y_acc /= 1.7

    press = true
  end     

  if btn(1) then
    player.direction = 1
    player.x_acc = 2.5
    player.y_acc /= 1.7
    press = true
  end

  if btn(2) then
    player.direction = 2
    player.y_acc = 2.5  
    player.x_acc /= 1.7
    press = true
  end

  if btn(3) then
    player.direction = 3
    player.y_acc = -2.5
    player.x_acc /= 1.7
    press = true
  end

  if press then
    was_pressed = true
    return true
  else
    was_pressed = false
    return false
  end     

end

-- displays the timer on the hud.
function handle_timer()
  if seconds == 0 and minutes == 0 then
    cls()
    music(10)
    wait(30)
    _init()
    return
  end

  time_counter += 1

  if time_counter == 30 then
    time_counter = 0
    handle_time()
  end
  

  if seconds < 10 and
   minutes < 10 then
   print(0, camx + 105, camy + 2, 7)
   print(minutes, camx + 109, camy + 2, 7)
   print(":", camx + 113, camy + 2, 7)
   print(0, camx + 119, camy + 2, 7)
   print(seconds, camx + 123, camy + 2, 7)        
   elseif minutes < 10 then
    print(0, camx + 105, camy + 2, 7)
    print(minutes, camx + 109, camy + 2, 7)
    print(":", camx + 113, camy + 2, 7)
    print(seconds, camx + 117, camy + 2, 7)
    elseif seconds < 10 then
      print(minutes, camx + 105, camy + 2, 7)
      print(":", camx + 114, camy + 2, 7)
      print(0, camx + 119, camy + 2, 7)
      print(seconds, camx + 123, camy + 2, 7)
    else         
      print(minutes, camx + 105, camy + 2, 7)
      print(":", camx + 114, camy + 2, 7)
      print(seconds, camx + 119, camy + 2, 7)
  end        
end

function handle_time()
  if seconds == 0 then
    seconds = 60
    minutes -= 1 
  end

  seconds -= 1
end

function init_animations()

  animating_sprites = {}

  for  i = 0, 128 do
    for j = 0, 128 do
      sprite_num = mget(i,j)
      if fget(sprite_num,1) then
        new_anim = {num_s=sprite_num, posx = i, posy = j, num=2}
        add(animating_sprites, new_anim)
      end
      if fget(sprite_num,2) then
        new_anim = {num_s=sprite_num, posx = i, posy = j, num=3}
        add(animating_sprites, new_anim)	
      end
      if fget(sprite_num,3) then
        new_anim = {num_s=sprite_num, posx = i, posy = j, num=4}
        add(animating_sprites, new_anim)
      end
      if fget(sprite_num,4) then
        new_anim = {num_s=sprite_num, posx = i, posy = j, num=5}
        add(animating_sprites, new_anim)
      end	
      if fget(sprite_num,5) then
        new_anim = {num_s=sprite_num, posx = i, posy = j, num=6}
        add(animating_sprites, new_anim)
      end	
    end 
  end
end

function _update()
  fade_effect()
  state_machine_update()
end

function _draw()
  anim_time_intro += 0.4
	palt(14,true)
	state_machine_draw()
end

function draw_top_floor()
	map(0)
end

function animate_objects_top()
	anim_time += 0.05
	for a in all(animating_sprites) do
   spr(a.num_s+anim_time%a.num,a.posx*8, a.posy*8)		
 end
end


function draw_objects()
  animate_objects_top()
  spr(195, 290, 95)
  spr(196, 298, 95)
  spr(211, 290, 103)
  spr(212, 298, 103)
end


function titleinit()
  game.state_mode = 0
end

function gameinit()
  game.state_mode = 1
  game.state_game = 1
  music(5)
  player.task = "suit"
end

function state_machine_update()
  if(game.state_mode == 0) then --title screen mode
    titleupdate()
  elseif(game.state_mode == 1) then -- game ongoing
    moveloop() 
  end
end

function title_update()
  
  repeat
  	btn(4,0) -- pressed z then move()starts game
  until(btn(4, 0))
end


function analyze_action()
  if(game.text == "change floor" and (fget(160,7) or fget(161,7))) then
    fading_out = true
    wait(20)
    changefloor() end	
  	if(game.text == "car" and (fget(154,7) or fget(155,7) or fget(156,7) or fget(157,7))) then
      do_ending()
    end
    if (game.text == "main door" and fget(184,7)) then
      if(player.task == "done") then change_to_exit()
       else display_text("can't leave yet! still have more items to find.", camx, camy + 58, camx + 125, camy + 125)
        wait(80) end
    end  
      --here place the processes used in common in all states, ex movement
    if(player.task == "suit") then  --if current task is searching for suit then sees in what part of the clues he is in
      if(player.currentclue == 1) then
        if (game.text == "main wardrobe" and fget(103, 7)) then
          cls()
          sfx(25)
          display_text("quit toying around! i gotta get to work!", camx, camy + 58, camx + 125, camy + 125)
          wait(50)
          fset(103,7,false)
          player.currentclue = 2
          elseif (game.text == "main wardrobe") then
            display_text("there's nothing more of interest in there.", camx, camy + 58, camx + 125, camy + 125)
            wait(50)
          end
                --checks if player got the clue, in that case stores the current clue
          elseif(player.currentclue == 2) then
            if (game.text == "teddy bear" and fget(226, 7)) then
              cls()
              sfx(23)
              display_text("there's a key behind the teddy bear... what could it open?", camx, camy + 58, camx + 125, camy + 125)
              wait(75)
              fset(206,7,false)
              player.currentclue = 3
            elseif (game.text == "teddy bear") then
              display_text("you better leave it alone or the kids won't find it", camx, camy + 58, camx + 125, camy + 125)
              wait(50)
            end
            elseif(player.currentclue == 3) then
              if (game.text == "kids wardrobe" and fget(79, 7)) then
                cls()
                music(11)
                display_text("you now have your suit! still not done though... ask your wife for what's missing!", camx, camy + 58, camx + 125, camy + 125)
                wait(80)
                music(5)
                wait(50)
                fset(206,7,false)
                player.currentclue = 1
                player.task = "suitcase"
            elseif(game.text == "kids wardrobe") then
              display_text("no need for tyding that up now", camx, camy + 58, camx + 125, camy + 125)
              wait(80)
            end
          end
          elseif(player.task == "suitcase") then  --if current task is searching for suit then sees in what part of the clues he is in
            if(player.currentclue == 1) then
              if (game.text == "bed") then
                cls()
                sfx(33)
                display_text("hmm, your case? you were with it in the bathroom for some reason... 'maximizing those gains', as you call it.", camx, camy + 58, camx + 125, camy + 125)
                wait(50)
                player.currentclue = 2
              end
          elseif(player.currentclue == 2) then
            if (game.text == "toilet" and (fget(224, 7) or fget(225, 7) or fget(240, 7) or fget(241, 7) )) then
              cls()
              sfx(25)
              display_text("i sure gotta keep my cool...", camx, camy + 58, camx + 125, camy + 125)
              wait(50)
              fset(224,7,false)
              fset(225,7,false)
              fset(240,7,false)
              fset(241,7,false)
              player.currentclue = 3
          elseif game.text == "toilet" then
             display_text("not happening", camx, camy + 58, camx + 125, camy + 125)
             wait(50)	
          end
          elseif(player.currentclue == 3) then
            if (game.text == "fridge" and fget(39, 7)) then
              cls()
              music(11)
              display_text("you have found your suitcase! ask your wife what's next!",camx, camy + 58, camx + 125, camy + 125)
              wait(80)
              music(5)
              wait(50)
              fset(39, 7, false)
              player.currentclue = 1
              player.task = "papers"
          elseif game.text == "fridge" then
            display_text("only leftovers in there", camx, camy + 58, camx + 125, camy + 125)
            wait(80)	
          end
        end
        elseif(player.task == "papers") then  --if current task is searching for suit then sees in what part of the clues he is in
          if(player.currentclue == 1) then
            if (game.text == "bed") then
              sfx(33)
              cls()
              display_text("how should i know where you left the report? it should be in your case. ", camx, camy + 58, camx + 125, camy + 125)
        			wait(20)
        			cls()
              display_text("you really do need to pay more attention to these things.", camx, camy + 58, camx + 125, camy + 125)
              player.currentclue = 2
            end
              --checks if player got the clue, in that case stores the current clue
            elseif(player.currentclue == 2) then
              sfx(25)
              cls()
              display_text("boy, i sure am hungry...", camx, camy + 58, camx + 125, camy + 125)
              player.currentclue = 3
            elseif(player.currentclue == 3) then
              if (game.text == "dining table" and (fget(141, 7) or fget(112, 7) or fget(101, 7)) ) then
                music(11)
                cls()
                display_text("your suitcase! but what comes next... wild guess, maybe you should ask your wife!", camx, camy + 58, camx + 125, camy + 125)
                wait(80)
                music(5)
                fset(141, 7, false)
                fset(112, 7, false)
                fset(101, 7, false)
                player.currentclue = 1
                player.task = "keys"
              elseif game.text == "dining table" then
                display_text("not cleacing this mess  up", camx, camy + 58, camx + 125, camy + 125)
                wait(80)
              end
            end
          elseif(player.task == "keys") then  --if current task is searching for suit then sees in what part of the clues he is in
           if(player.currentclue == 1) then
            if (game.text == "bed") then
              cls()
              sfx(33)
              display_text("i'm starting to get annoyed with all of your questions... just go where you can breathe the easiest indoors to find your keys.", camx, camy + 58, camx + 125, camy + 125)
              player.currentclue = 2
            end
             --checks if player got the clue, in that case stores the current clue
          elseif(player.currentclue == 2) then
            if (game.text == "vase" and (fget(195, 7) or fget(196, 7) or fget(211, 7) or fget(212,7))) then
              music(11)
              cls()
              display_text("you have found the last item you needed to leave your house: your keys! good job! get to your car outside and get ready to face your boss!", camx, camy + 58, camx + 125, camy + 125)
              wait(80)
              music(5)
              player.task = "done"
              player.currentclue = 0
              elseif(player.currentclue == 0) then
                if (game.text == "main door" and fget(184, 7)) then
                  change_to_exit()
                  else if (game.text == "main door") then
                    display_text("can't leave yet! still have more items to find", camx, camy + 58, camx + 125, camy + 125)
                    wait(80)
                  end
                end
              end
            end
          end
        end

function do_ending() 
    music(40)
    cls()
    sfx(33)
    display_text("nicely done! now to start the ignition!!!",  camx, camy + 64, camx + 127, camy + 127)
    wait(40)
    cls()
    sfx(32)
    display_text("wait.",  camx, camy + 64, camx + 127, camy + 127)
    wait(70)
    cls()
    sfx(32)
    display_text("humm... so it must be in this pocket...", camx, camy + 64, camx + 127, camy + 127)
    wait(70)
    cls()
    sfx(32)
    display_text("no...", camx, camy + 64, camx + 127, camy + 127)
    wait(60)
    cls()
    sfx(32)
    display_text("where did i put my mobile...", camx, camy + 64, camx + 127, camy + 127)
    wait(50)
    cls()
    sfx(32)
    display_text("oh.", camx, camy + 64, camx + 127, camy + 127)
    wait(50)
    cls()
    sfx(32)
    display_text("it's on my bedside table.", camx, camy + 64, camx + 127, camy + 127)
    wait(50)
    cls()
    sfx(22)
    wait(20)
    sfx(32)
    display_text("oh.", camx, camy + 64, camx + 127, camy + 127)
    wait(30)
    cls()
    sfx(22)
    wait(20)
    sfx(22)
    wait(60)
    music(10)
    wait(5)
    display_text("you win?...", camx + 40, camy + 64, camx + 127, camy + 127)
    wait(80)
    _init()
  end

function change_to_exit()
      player.x = 526
			player.y = 40
end

            
           function state_machine_draw()
 		    if(game.state_mode == 0 ) then --draws game screen
  			

      elseif(game.state_mode == 1) then
        gamedraw() end
      end


      function initscreen_draw()
      print('bob', 58 , 58, 8)
  		print("press Ž to start the game",15,70,7)
      end

      function gamedraw()
       cls()

       draw_top_floor()
       draw_objects()
       draw_player()
       draw_hud()


       if(game.text  !=  "nothing") then 
        display_text(game.text, camx + 4, camy + 121, camx + 80, camy + 121)

        if (btn(4)) then
         analyze_action()
       end
       game.text = "nothing"   
     end
   end

   function draw_player()
    if was_pressed and player.direction == 1 then

      spr(202,player.x,player.y-4)
      spr(203,player.x+8,player.y-4)
      spr(218,player.x,player.y+4)
      spr(219,player.x+8,player.y+4)

      elseif was_pressed and player.direction == 0 then
       spr(206,player.x,player.y-4, 1, 1, true, false)
       spr(207,player.x-8,player.y-4, 1, 1, true, false)
       spr(222,player.x,player.y+4, 1, 1, true, false)
       spr(223,player.x-8,player.y+4, 1, 1, true, false)
       elseif was_pressed and player.direction == 3 then
         spr(238,player.x,player.y+4, 1, 1, false, true)
         spr(239,player.x+8,player.y+4, 1, 1, false, true)
         spr(254,player.x,player.y-4, 1, 1, false, true)
         spr(255,player.x+8,player.y-4, 1, 1, false, true)
         elseif was_pressed and player.direction == 2 then
           spr(238,player.x,player.y-4)
           spr(239,player.x+8,player.y-4)
           spr(254,player.x,player.y+4)
           spr(255,player.x+8,player.y+4)
           elseif not(was_pressed) and player.direction == 1 then
             spr(204,player.x+4,player.y-4)
             spr(220,player.x+4,player.y+4)
             elseif not(was_pressed) and player.direction == 0 then
               spr(204,player.x-4,player.y-4, 1, 1, true, false)
               spr(220,player.x-4,player.y+4, 1, 1, true, false)
               elseif not(was_pressed) and player.direction == 2 then
                 spr(236,player.x-4,player.y+4)
                 spr(237,player.x+4,player.y+4)
               else
                 spr(236,player.x-4,player.y+4, 1, 1, false, true)
                 spr(237,player.x+4,player.y+4, 1, 1, false, true)
               end
             end

-- draws hud with the timer, selected object, current goal.
function draw_hud()
  rectfill(camx, camy, camx + 127, camy + 8, 8)
  rectfill(camx, camy + 119, camx + 127, camy + 127, 8)
  handle_timer()
  print_hint_tracker()
end

function print_hint_tracker()
  if player.task == 'suit' then
    print('0/4 items', camx + 90, camy + 121, 7)
    elseif player.task == 'suitcase' then
     print('1/4 items', camx + 90, camy + 121, 7)
     elseif player.task == 'papers' then
      print('2/4 items', camx + 90, camy + 121, 7)
      elseif player.task == 'keys' then
        print('3/4 items', camx + 90, camy + 121, 7)
      end
    end

    function wait(a) for i=1, a do flip() end end

    function display_text(string, x_initial, y_initial, x_final, y_final)
     local text_x= x_initial
     local text_y= y_initial
     for i=1, #string do
       print(sub(string,i,i),text_x,text_y,7)
       text_x+=4
       if(text_x > x_final) then 
        text_x = x_initial
        text_y += 6
      end
      if(text_y > y_final) then
        text_x = x_initial
        text_y = y_initial
      end
      wait(2)
    end
  end

  function clearline(xposi,xposf,ypos)
   rectfill(xposi,ypos,xposf,ypos+6,0)
 end

 function clearlines(xposi,yposi,xposf,yposf)
   wait(20)

   for i=yposi,yposf,6 do
    clearline(xposi,xposf,i)
  end
end

function fillobjectarray()

  local new_object = {}
  new_object.tag = "bed"
  new_object.sprites = {9,10,11,12,25,26,27,28,41,42,43,44,57,58,59,60}
  add(objects_array,new_object)
  local new_object1 = {}
  new_object1.tag= "tv"
  new_object1.sprites = {62,63}
  add(objects_array,new_object1)
  local new_object2 = {}
  new_object2.tag = "stairs"
  new_object2.sprites = {14}
  add(objects_array,new_object2)
  local new_object3 = {}
  new_object3.tag = "toilet"
  new_object3.sprites = {224, 225,240,241}
  add(objects_array,new_object3)
  local new_object4 = {}
  new_object4.tag = "main wardrobe"
  new_object4.sprites = {103}
  add(objects_array,new_object4)
  local new_object5 = {}
  new_object5.tag = "crib"
  new_object5.sprites = {73,74,75}
  add(objects_array,new_object5)
  local new_object6 = {}
  new_object6.tag = "candle"
  new_object6.sprites = {65,66}
  add(objects_array,new_object6)
  local new_object7 = {}
  new_object7.tag = "kids wardrobe"
  new_object7.sprites = {79, 95}
  add(objects_array,new_object7)
  local new_object8 = {}
  new_object8.tag = "bedside table"
  new_object8.sprites = {104, 105, 106}
  add(objects_array, new_object8)
  local new_object9 = {}
  new_object9.tag = "teddy bear"
  new_object9.sprites = {226}
  add(objects_array, new_object9)
  local new_object10 = {}
  new_object10.tag = "fridge"
  new_object10.sprites = {39}
  add(objects_array, new_object10)
  local new_object11 = {}
  new_object11.tag = "change floor"
  new_object11.sprites = {160,161}
  add(objects_array,new_object11)
  local new_object12 = {}
  new_object12.tag = "dining table"
  new_object12.sprites = {101, 112, 141}
  add(objects_array, new_object12)
  local new_object13 = {}
  new_object13.tag = "vase"
  new_object13.sprites = {195, 196, 211, 212}
  add(objects_array, new_object13)
  local new_object14 ={}
  new_object14.tag = "main door"
  new_object14.sprites = {184}
  add(objects_array, new_object14)
  local new_object15 ={}
  new_object15.tag = "car"
  new_object15.sprites = {154,155,156,157}
  add(objects_array, new_object15)


end

function check_interaction(id)
 for i = 1, count(objects_array) do

  for a = 1, count(objects_array[i].sprites) do
    if(objects_array[i].sprites[a] == id ) then
      game.text = objects_array[i].tag
    end


  end

end


end

function moveloop()

  previousposx = player.x
  previousposy = player.y

  if move() then
    for i = 1, count(all_sprites) do
      if detect(all_sprites[i]) then
        player.x = previousposx
        player.y = previousposy
        player.x_acc = -player.x_acc
        player.y_acc = -player.y_acc
        check_interaction(all_sprites[i].id)
      end
    end
  end
  update_cam_position()
end



local fadetable={
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,1,1,1,1,1,1,0,0,0,0,0,0,0,0},
{2,2,2,2,2,2,1,1,1,0,0,0,0,0,0},
{3,3,3,3,3,3,1,1,1,0,0,0,0,0,0},
{4,4,4,2,2,2,2,2,1,1,0,0,0,0,0},
{5,5,5,5,5,1,1,1,1,1,0,0,0,0,0},
{6,6,13,13,13,13,5,5,5,5,1,1,1,0,0},
{7,6,6,6,6,13,13,13,5,5,5,1,1,0,0},
{8,8,8,8,2,2,2,2,2,2,0,0,0,0,0},
{9,9,9,4,4,4,4,4,4,5,5,0,0,0,0},
{10,10,9,9,9,4,4,4,5,5,5,5,0,0,0},
{11,11,11,3,3,3,3,3,3,3,0,0,0,0,0},
{12,12,12,12,12,3,3,1,1,1,1,1,1,0,0},
{13,13,13,5,5,5,5,1,1,1,1,1,0,0,0},
{14,14,14,13,4,4,2,2,2,2,2,1,1,0,0},
{15,15,6,13,13,13,5,5,5,5,5,1,1,0,0}
}

function fade(i)
for c=0,15 do
if flr(i+1)>=16 then
pal(c,0)
else
pal(c,fadetable[c+1][flr(i+1)])
end
end
end

-- updates the camera position.
function update_cam_position()
  camx = camx + ((player.x-64)-camx) * 0.3
  camy = camy + ((player.y-64)-camy) * 0.3
  camera(camx, camy)
end

function fade_effect()
  if fade_index > 14 and fading_out then
    fading_out = false
    fading_in = true
    return
  end
  
  if fade_index < 1 and fading_in then
    fading_in = false
  end

  if fading_out then
  	fade_index += 1
    fade(fade_index)
    
    elseif fading_in then
     fade_index -= 1
     fade(fade_index)
   end

 end

 function changefloor()
  
  if(game.floor == 1) then 
   player.x = 350
   player.y = 45
   game.floor = 0
   elseif(game.floor == 0) then
     player.x = 110
     player.y = 70
     game.floor = 1 end

   end


   function checkotheriteractions()
     if (game.text == "tv" and (fget(62, 7) or fget(63,7))) then
      cls()
      sfx(25)
      display_text("you have no time to watch tv right now!", 40, 90, 110, 150)
      wait(50)
    end
    if (game.text == "crib" and (fget(73,7) or fget(74,7) or fget(75,7))) then
      cls()
      sfx(25)
      display_text("don't wake up the kids!", 40, 90, 110, 150)
      wait(50)
    end
    if( game.text == "candle" and (fget(65,7) or fget(66,7))) then
      cls()
      sfx(25)
      display_text("huh it's just a candle", 40, 90, 110, 150)
      wait(50)
    end
  end


function first_dialogue()  
  cls()
  sfx(33)
  display_text("honey? you're awake?", 7, 110, 123, 122)
  wait(50)
  
  cls()
  sfx(32)
  display_text("*mumble*", 7, 110, 123, 122)
  wait(50)
  
  cls()
  sfx(33)
  display_text("your suit? ugh.. again? i think i saw something in the wardrobe", 7, 110, 123, 122)
  wait(50)
  
  cls()
  sfx(32)
  display_text("*mumble*", 7, 110, 123, 122)
  wait(50)
  
  cls()
  sfx(33)
  display_text("if you need anything else, just ask me, okay?", 7, 110, 123, 122)
  wait(50)
  cls()
end

-- displays the menu dialog.
function display_title_text()
  cls()
  music(0)
  display_text("hey bob, how you doin', bob?", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("it's time to wake up, buddy.", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("you're late.", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("again...", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("man, your boss even texted you.", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("that's a nice way to tell you you're screwed.", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("oh!", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("wait up, wait up...", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("he said he'd give you 20 minutes to get there!", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("that leaves you about...", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("uhm...", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("the amount of time on the top of the screen!", 7, 110, 123, 122)
  wait(20)
  cls()
  display_text("get movin'.", 7, 110, 123, 122)
  wait(20)
  cls()
end

__gfx__
55555555eee1ceee0005555444444444555555553333333344444444ffffffff0000000077777777766666dd66666666666ddddd4aa99aa95545444455555555
55555555ee11ccee0000555e44444444555555553333333344444444ffffffff00000000aa777666666ddddddd6666666ddddddd44a99aa95554544455555555
55555555ee11cceee00000ee44444444555555553333333344444444ffffffff00000000a7a66666666dd5dd5d66666666dddddd44499aa95555444455545545
44444555ee11cceeee11ccee44444444555555553333333344444444ffffffff000000007a766666676ddddd5dd6666666dddddd44449aa95554544455455444
44444555ee11cceeee11ccee44444444777777773333333344444444ffffffff000000007a766666776dddddddd666666666dddd44444aa95545444454545444
44444555e05555eeee11ccee44444444747474743333333344444444ffffffff0000000077666666776dd6ddddd6666666d6dddd444444a95554544455444444
444445550055555eee11ccee44444444474747473333333344444444ffffffff0000000077666677777dd6ddd56d66666656dddd444444495545444454444444
4444455500555554eee1ceee44444444444444443333333344444444ffffffff0000000077666677777dddddd6dd666656666ddd444444445554544444444444
55555555555555557777777755555555666666667777777788888888828282829999999977766677677ddddd66dd666d66666ddd544444445555555555555555
555555555555555577777777555555556666666677777777888888888288828899999999a7666677667dddddddd5666d56666ddd554444445555555554545454
555555555555555577777777555555556666666677777777888888888282828288888888a7666677666ddddd6d65666d66666ddd554444445555555555454545
555555555555555577777777555555556666666677777777888888888882888288888888aa666676666ddddddd6666666d666ddd554544445555555554545454
555555555555555577777777555555556666666677777777888888888282828288888888a7666676776dddddd66666566d666ddd555454440000000044444444
000000000000000077777777555555556666666677777777888888888288828888888888aa66667676ddddddd66665d66666dddd555544444545454044444444
4554545445454545777777775555555566666666777777778888888888828282888888887a666666777dddddd6566d66666dd5dd555455445454545444444444
445545545454545477777777555555556666666677777777888888888282888288888888a7666666677dddddddd6dd66667d55dd555554544444444444444444
66666555555555552222222299999999aaaaaaaabbbbbbbb111111116000000088888888a766666666766dddddd6d666d67d5ddd444445454994994455555555
66665550000000052222222299999999aaaaaaaabbbbbbbb111111116555555588888888aa6666676676dddd6d566666d67dd6dd444544559444494444554555
66665550000000052222222299999999aaaaaaaabbbbbbbb1111111165555555888888887a6666677a76dddddd556d6d6675dddd444445559499494445545555
66665550000000052222222299999999aaaaaaaabbbbbbbb1111111165555555888888887a6666777776ddddd666dd6666756ddd444454559944444444455555
66665550000000052222222299999999aaaaaaaabbbbbbbb1111111165555555888888887a666677776dddddd65dd6667d5566dd444545559449494444444445
66666550000000052222222299999999aaaaaaaabbbbbbbb111111116555555588888888aa66666776ddddddd6ddd667d5566ddd444444554944444444444545
66656550000000052222222299999999aaaaaaaabbbbbbbb111111116555555599999999aa66666646d4ddddddd6667dd5666ddd444545559944944444444455
66666655555555552222222299999999aaaaaaaabbbbbbbb111111116000000099999999a76666669444dddddd5666dd5d776d6d444454554994449444444444
544444455555555550000005500000055555555555555555555555554444444494949494a76666744444ddddddd566d5dd767d6d470444440000000000000000
544444450000000050000005000000055000000050000005500000004444444494949494a766776f944465656555dddd6666556d470044446776667667777676
554544450000000050000005000000055000000050000005500000004444444444444444a77777ff944456666555d6d777d6666d440004447676676665576657
554454450000000050000005000000055000000050000005500000004444444444444444a77777ff94445655555677777d7775dd444000446677556756775657
555545550000000050000005000000055000000050000005500000004444444444444444a77779f99444666555777777767775dd444400046766676666766676
555454550000000050000005000000055000000050000005500000004444444444444444677779444445666505677777776656dd444440000000000000000000
555555550000000050000005000000055000000050000005500000004949494944444444677774444455665505677776666656dd444444005454545454545454
555555555555555550000005555555555000000550000005555555554949494944444444666666666666555505777766666dddd5444444404545454545454545
111111114a4449944aa4499a91911990191199900000000000000000099919110911911111111111111111115282828511111111666666661111111188888888
111111114a4aa4449a4aa4aa11199900111199000909090909090909001911110019119155955595559559955828282522999221c6c6c6c61111111122282888
1111111149a77a4994a77a4a11911990111919909999191919919999099119110999911156666665566666655282828529999921666666661111111122822888
1111111194a77a4a94a77a4411919900191119001991999191919111009991110099191156999965569999655828282599999991c6c6c6c61111111122222228
11111111a44aa944a44aa444911119101199999011119911111111910999111109911911569ff965569ff9655282828599999991666666661111111122228888
111111114944444499444a4a111919001911910019991119111911110099911100199111569ff965569ff9655828282529999921c6c6c6c61111111122222228
1111111194a9a99a9a44449a11111110111119101191111911911991099111110999199152828285528282855555555522999221666666661111111122222828
11111111999449a449a99a4419991100191191001911191111111111001991910019911158282825582828250000000011111111c6c6c6c61111111122222228
099199110991911111911990191119104444444445444444333333b3333b33bb1111111331133111333333313333333311111000111111111111010022222288
1199911199991991191191911199911144544444444444443b33b3333b3bbbb31111131113311311333333113333333311010100111111111111100022282228
9911911199119111111119191911919144444544444444453b33bb33b33bbbb73313313133333111333331313331133311111000101110111101010022222228
199911111191191111191999119199994444444444444544333333b33333bb733333313333333331333333113331333111110100111011111111100022222828
99111911919911111111111111991111444444544454445433333333b3b3b3bb3333333333333333331331311133311111101000010101010101010022222228
1119191119911111111911911111119145444444444445443333333bb33bb7733333333333333331333111313313111111110100101010101010100022222228
191111111111911111111111111191914444454444444444b3b333333b33b3b33333333333333333111111111111333111011000000000000000000022222828
11111111191111111111111111111111444444444444444433b3333333bb3bb33333333333333333111111111111111111110100000000000000000022222228
191111111111111177a777a5777aa79577777777477777749aa99aa9a777a7aa2288222288888882888888886666666666766666767767776667666649999994
1111111111111191666aa9a56aa69a9566666667444774449aa99aa9a777a7aa228222828882828228288222c676c6c67776c6c677777777c7c6c7c6999aa999
119119111111111166669695666aa66566666667447777449aa99aa9a777a7aa2222222288828822282282226766666667676766677667776667667799aaaa99
11111111119111116a9aa69566a6a9a566666667477776649aa99aa9a777a7aa228228228882222228228882c676c676777776c6c7777777c6c6c6c69aa77aa9
111111919111191166a6a9a566a9a66566666667477666649aa99aa9a777a7aa282222228888222228822222766666667676676667776667666667769aa77aa9
111191111911119166a6a6a56a6aaaa566666667447666449aa99aa9a777a7aa822222228282222222222222c6c7c6c677c7c7c6c6c677c7c7c6c6c699aaaa99
191111111111111166aa66656666666566666667444764449aa99aa9a777a7aa22228222822222228822222276666766777766766667666666667667999aa999
11111111111911116aa6666566a6aa6566666667477777749aa99aa9a777a7aa22822222822222222228822277c6c7c677c7c777c6c6c7c6c6c6c6c649999994
44444444555595559959995555959999555555559599555555595999999999995555555560000000000000065555550fff05555547475555fffff44455555555
74477447955599559995995555599999559555959555955555595559595999595555955560005500005500065555550fff05555544775555fffff44455555555
74777747959555559955559559599599555599559959559555999999999559955595595560055550055550065511150fff05111547475555fffff44455555555
77777667595955555995955555559559559555999595595559559959595995595555559560005500005500065511150fff05111544775555fffff44455555555
77766667559959559555555555599595595595999959555555955999599559595595995960000000000000065511150fff05111547475555fffff44477775555
64766647995559555959595555959559595999999995959555599599555595559959999566666666666666665511150fff05111544775555fffff44474775555
644764479959955595555555555555955955955995555555559559995555559559999995fffff777777fffff5555550fff05555547475555fffff44447475555
444444449999595955555555555555555595999995959555555559595595555599999999ffffffffffffffff5555550fff05555544775555fffff44444775555
eeeeeeeeffffffffeeeeeeeeffffffffaa777777aaaaaa7776766666777757663b313b3333333333333333313131111131313113444444441111111100000000
efeeeeeeefffffffffeefefeffffffff996666679999996765655556666565563bb3333133339333339331333313133113331111444444441111111100000000
eeefefeeeefeffefffffeeeeffffffff9999666799999967665655566666555633b13b1b93933333333339333333311113b11b13444444441111111100000000
eeffffffefffeeffffffffeeffffffff9999966799999967666555566655655733b3333133339933399333313b331113313b3113444444441111111100000000
eeefffeeeeeffeffffffeefefefffeff999999679999996766665657656665653b33bb1339993333333339333b3b33313b331313444444441111111100000000
feffeffeeeefeffffffffeeeffefefef999999679999996766565656666655553b31333393939333333939393333131133333b33444444441111111100000000
eeffffffeefeeeefffeeefeeefefeefe9999996799999967666665576655665533333133993933939393393333b3b3b331333333444444441111111100000000
ffffffffeeeeeeeefeeeeeeeeeeeeeee99999967999999676665666766656556333b333399999393333333393333333333333333444444440000000000000000
566656556555555555550fff00000000777777777777777777777777557565570000000000000000555555555555555555555555555555555555555555555555
556565555656555555550fff00000000666666676666666766666667655565670aaaaaaaaaaaa990555555555555555555555555555555555555555555555555
555656655555555555550fff00000000666666679666666766669667565656570aaaaaaaaaaaaa90555555555555555555555555555555555555555555555555
555556555655555555550fff00000000666666676696666766666667556565670aaaaaaaaaaaaa90555555555555555555555555555555555555555555555555
555555565555555555550fff00000000666666679666666766666697666665670aaaaaaaaaaaaa90555555555555555555555555555555555555555555555555
555555656556555555550fff00000000696669676966966766696967666666670aaaaaaaaaaaaa90555555555555555555555555555555555555555555555555
555555555655555555550fff00000000666966679696966766966697666666670aaaaaaaaaaaaa90555555555555222222222555555555555555555555555555
555555555555555555550fff00000000699669676966666766669967666666670aaaaaaaaaaaaa90555555555222222222222225555555555555555555555555
00000000000000005555555550000000555555555555555550000000555555550aaaaaaaaaaaaa90555566666662222222222227666676666605555555555555
00006000000600005555555550000000500000000000000550000000000000050aaaaaaaaaaaaa90559866666662222222222227666666666676055555555555
00006600006600005555555550000000500000000000000550000000000000050aaaaaaaaaaaaa90559666666622222222222227666666666677655555555555
06666660066666605555555550000000500000000000000550000000000000050aaaaaaaaaaaaa90556666666662222222222222666666666666665555555555
06666660066666609999999950000000500000000000000550000000000000050aaaaaaaaaaaaa90569866666622222222222222666666666666665555555555
00006600006600005555555550000000500000000000000550000000000000050aaaaaaaaaaaa990559966666677777777777566666661616667765555555555
000060000006000099999999500000005000000000000005500000000000000500aa999999999990558811111111111111111111111111111111765555555555
00000000000000005555555555555555500000000000000555555555000000050000000000000000555111110011111111111111111110011111105555555555
00000000000000000000000050000005500000005000000550000005664433333443333300000000555111100001111111111111011100001111555555555555
00000000000000000000000050000005500000000000000000000005664433333443333300000000555555000005555555555555555500005555555555555555
00000000000000000000000050000005500000000000000000000005664433333443333300000000555555500005555555555555555550055555555555555555
00000000000000000000000050000005500000000000000000000005664433333443333300000000555555555555555555555555555555555555555555555555
00000000000000000000000050000005500000000000000000000005664433333443333300000000555555555555555555555555555555555555555555555555
00000000000000000000000050000005500000000000000000000005664433333443333300000000555555555555555555555555555555555555555555555555
00000000000000000000000050000005500000000000000000000005664433333443333300000000555555555555555555555555555555555555555555555555
00000000000000000000000055555555500000005555555550000005664433333443333300000000555555555555555555555555555555555555555555555555
eeeeeeeeeeeeeeeeffffffffaaaaa7777777777777777777777777773333333443333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
ee7777eeeeeeeeeef4ffffff99999667666666676666ff44444966673333333443333333eeeeeeeeeeeeee11cceeeeeeeee1ceeeeeeeeeeeeeeeeee1ceeeeeee
ee7776eeeee66677f444440f999996444a4666676664f444444966673333333443333333eeeeeeeeeeeeee11cceeeeeeee11cceeeeeeeeeeeeeeee11cceeeeee
ee7776eeee666677f444440f99994844348866676fff4445444466673333333443333333eeeeeeeeeeeeee11cceeeeeeee11cceeeeeeeeeeeeeeee11cc11cc0e
ee7776eeee666677f444440f99994883388886676ff44444449666673333333443333333eeeeeeeeee01cc11cceeeeeeee11cceeeeeeeeeeeeeeee11cccccc0e
ee7776eeeee66677f444440f9994a388abb844676ff44955499666673333333443333333eeeeeeeeee01105555eeeeeee05555eeeeeeeeeeeeeee05555d111ee
ee6666eeeeeeeeeef4ffffff9948833aab8844676ff49955549666673333333443333333eeeeeeeeeee11055555eeeee0055555eeeeeeeeeeeee0055555eeeee
eeeeeeeeeeeeeeeeffffffff998883333b8844676f459954499666673333333443333333eeeeeeeeeeee00555554eeee00555554eeeeeeeeeeee00555554eeee
eeeeeeeeeeeeeeeeffffffffa8888b3333334477ef4944544997777777777777eeeeeeeeeeeeeeeeeeee00055554eeee00055554eeeeeeeeeeee00055554eeee
eeeeeeeeeeeeeeeeff0000ff9888483338444467ef4499555596666766666667eeeeeeeeeeeeeeeeeeee0000555eeeee0000555eeeeeeeeeeeee0000555eeeee
eeeeeeeeeeeeeeeeff4444ff9994a4a8b88a4467ef4499545996666766666667eeeeeeeeeeeeeeeeeeee000000d111eee00000eeeeeeeeeeeee1100000eeeeee
eeeeeeeeeeeeeeeeff4444ff99944488b8844667ef4449544596666766666667eeeeeeeeeeeeeeeeeeeee011cccccc0eee11cceeeeeeeeeeeee11011cceeeeee
eeeeeeeeeeeeeeeeff4444ff9999448888886667ef4445544596666766666667eeeeeeeeeeeeeeeeeeeeee11cc11cc0eee11cceeeeeeeeeeeee1cc11cceeeeee
eeeeeeeeeeeeeeeeff4444ff9999944844886667ef4449554546666766666667eeeeeeeeeeeeeeeeeeeeee11cceeeeeeee11cceeeeeeeeeeeeeeee11cceeeeee
eeeeeeeeeeeeeeeef444444f9999966766666667ef4445545446666766666667eeeeeeeeeeeeeeeeeeeeeee1ceeeeeeeeee1ceeeeeeeeeeeeeeeeee1ceeeeeee
eeeeeeeeeeeeeeeeffffffff9999966766666667ef4444544496666766666667eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
66666666666666661221122100000000000000007f44445444977777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee44eeeeeeeeeeeeeeeeeeeeeee
c6c6c6c6c6c6c6c61228822100777000007777006f44495444466667eeeeeeeeeee1ceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee5555eeeeeeeeeeeeeeeeeeeeee
66666666666666661188881100700700007007006f44454544466667eeeeeeeeee11cceeeeeeeeeeeeeeeeeeee100eeeeeeee555550eeeeeeee001eeeeeeeeee
c6c6c6c6c6c6c7771182281100777700007007006f44454444466667eeeeeeeeee11cceeeeeeeeeeeeeeeeeeee1cceeeeeccc555550ccceeeeecc1eeeeeeeeee
66666666677777771882288100700700007007006f44455454466667eeeeeeeeee11cceeeeeeeeeeeeeeeee44e1cceeeecccc555500cccceeeecc1e44eeeeeee
c6c6c6c7776667771888888100777700007777006ff4455454466667eeeeeeeee05555eeeeeeeeeeeeeeee5555dc1eeee11115550001111eeee1cd5555eeeeee
66666677776667771188881100000000000000006ff4455544466667eeeeeeee0055555eeeeeeeeeeeeee555550c1eeeee111000000111eeeee1c555550eeeee
c6c6c677766667771188881100000000000000006ff4445445466667eeeeeeee00555554eeeeeeeeeeccc555550ccceeeeeeee0000eeeeeeeeccc555550cccee
66666676666667776666666666666666eeeeeeee7ff4444445477777eeeeeeee00055554eeeeeeeeecccc555500cccceeeeeeeeeeeeeeeeeecccc555500cccce
c6c6c67666666777c6c6c6c6c6c6c6c6eeeeeeee66f4445544466667eeeeeeee0000555eeeeeeeeee11115550001111eeeeeeeeeeeeeeeeee11115550001111e
66666677666667776666666666666666eeeeeeee66ff445444496667eeeeeeeee00000eeeeeeeeeeee111000000111eeeeeeeeeeeeeeeeeeee111000000111ee
c6c6c6c777666777c6c6777777c6c6c6eeeeeeee666ff44545499667eeeeeeeeee11cceeeeeeeeeeeeeec10000eeeeeeeeeeeeeeeeeeeeeeeeeeee00001ceeee
66666666677777776667755555666666eeeeeeee66644f4445494667eeeeeeeeee11cceeeeeeeeeeeeee111eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee111eeee
c6c6c6c6c6c6c6c6c6c755566677c6c6eeeeeeee66664f4444444667eeeeeeeeee11cceeeeeeeeeeeeee001eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee100eeee
66666666666666666667566666776666eeeeeeee66666ff466666667eeeeeeeeeee1ceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
c6c6c6c6c6c6c6c6c555555555555556eeeeeeee6666666666666667eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee

__gff__
0001010000008000000101010100000001010000000000000081010101000100000100008100008100810101010000000001010101010100008101010101838300030102000200020003010000000081020002000000000000000000000000810200020000810081010101000000000081000000000000000001010101010001
0000000000000000000000000081000000000000000000000000818181818100818100010101010100000000000000000000000101010001810000000000000080008081810000818100010101000101000000818101010100000101010001018181810000010100010001010101010181818181000000000100010100000101
__map__
0808080808080808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080800080000000000000000000000000000000000000000000000000000000000000000070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080800000000000000000000000000a4313131313131313131a700000000000800000000101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080800000000000000000000000000b7058c588b588b88565732000000000808000000008d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080800000000000000000000000000b80505050e0e0e0e0e0ea0000008080808000000005657565757565757c76464c8885757578857560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080000000000000000000000000000b80505050e0e0e0e0e0ea00800080808080808080057565657568c5788c76464c8575657565756570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080808080808080808080808083131313131313131a700000000000000000000000000b70505050e0e0e0e0e0ea0080008080808080808088856575756885756c76464c8885757578856570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080808080808080808080808a10e0e0e0e0e5856563200080800000000000000000000321414143631313131312108000808080808080808578c578856575657c76464c8578c88565757560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080808080808080808080808a10e0e0e0e0e055657b431313131313131a7000000000032648c8b97976496620b32000008080808080008085756578857578857c76464c8575788575756560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080808080808080808080808a10e0e0e0e0e055656b34147604e4ee25c32000000000032948a8864c5c664620c3200000808080808000808568c568888565757c76464c8575657885757570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808a43131313131313131313131a5050505524550604e4e265c3200000000003284898a64d5d66464863200080808080808000808568c575757565756c76464c8578857565657560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808320f1f1f1f103e3e111f1f2f330505054e60604e4e4e265c3200000000003285956464e5e66464873200080808080808000808d7d7d7d7d7d7d7d764646464d7d7d7d7d7d7d70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000008000032670d663737373737375455060505054e4e4e4e4e4e265c32000000000032c3c46464f5f66464873208000808080808000808d7d7d7d7d7d7d7d764646464d7d7d7d7d7d7d70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000032670666171717171717060606050505354f4e494e26495c32000008080032d3d464646464646464320808080808080800080813131313131313139a9b9c9d9e9f13131313130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000326706661717171717175506545b5b5a325f5d4b5d5d4b5e3200080808003231312190911336313131313131313135080808081313131313131313aaabacadaeaf13131313130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000326706662e3838383838542d354d4d4da631313131313131330808080808326f751313131313766f3280797a047f32080808081313131313131313babbbcbdbebf13131313130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000326706662e090a0b0c1d062d324d4d4d4d4d4d6e6d32080808080808080832777217171717177377070707077e7d3208080808a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000326706662e191a1b1c13062d324d4d4d4d4d4d6e6e3208080808080808083213178d8d708d8d171307c27c927e7d3208080808080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000320f06662e292a2b2c13062d324d4d4d4d4d4d4d4d320808080808080808321317658d6f8d65171307c27c927e7d3208080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000320666696a393a3b3c686830326b6b4d4d4d4de0e13208080808080808083213178d8d708d8d1713070707077e7d3208080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a33131313131313131313131b66c6b4d4df2f3f0f1320808080808080808327871171717171774780707070707273208080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000080000000000000808a63131313131313131330808080808080808326f751313131313766f3581838383823208080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000808080808080808080808080808080808080808a3313131313131313131b531313131313300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000808080808080808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000080808080808000808080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000080808080808000808080808080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000808080808000808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000808080808080808080000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000080808080808080808080800000808000008080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000808080808080808080808080808080808000008000800080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000080808080800080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010c00000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c043000000000000000
010c000021044000001c044000001d04400000200440000021044000001c044000001a04400000200440000021044000001c044000001d04400000200440000021044000001c044000001a044000000000000000
010c000018044000001c044000001f044000001c0440000024044000001f044000001c044000001f044000002004400000220440000020044000001f0440000024044000001f0440000000000000000000000000
010c00000c0430000024615000000c04324615000000c0430c0430000024615000000c0430000024615000000c0430000024615000000c04324615000000c0430c0430000024615000000c043000002461500000
010c0000260440000020044000001d044000001a04400000240440000021044000001d0440000018044000001a044000001d044000001f04400000200440000024044000001f0440000000000000000000000000
010c00002d0222d7163002230716327220000000000000002d0222d71630022307162c7220000000000000002d0222d71630022307162b7220000000000000002d0222d716300223071629722000000000000000
010c0000247500000028750000002b750000001f75000000207501f7511e7511d7511d75100000000001a7501b750000001f75000000000000000000000187501a750000001f7500000000000000000000000000
010c00000214000000091400000002140000000014000000021400000009140000000214000000001400000002140000000914000000021400000000140000000214000000091400000002140000000000000000
010c00000014000000041400000007140000000414000000061400000009140000000c14000000091400000002140000000514000000091400000005140000000414000000091400000007140000000000000000
01160000210421d04218042240422604624042210521d052200421d04719042000001f0421c04618042000001a0421d0420000020042210421d0421a041000001c042000001f052000002405022050000001d042
011600000c0430c04300000000000c0430c04300000000000c0430c04300000000000c0430c04300000000000c0430c04300000000000c0430c04300000000000c0430c04300000000000c0430c0430000000000
011600000515500000051550000005155000000515500000011550000001155000000015500000001550000002155001050215500105021550010502155000000115500005011550000500155230050415500155
011600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000242100000024210000002422000000
011600002404200000000001d0422304200000000001d04222041210421f0411d042190411c0421f0411c0421a04200000000001d0421904200000000001d042180420000000000200421f042000000000000000
011600000c0430c04300000000000c0430c043000000000000000000000000000000000000000000000000000c0530c053246250c053000000c05324625000000c0530c053246250c053000000c0532462500000
011600000000000000000000000000000000000000000000000000000000000000000000000000000000000026020290202b0202902025020290202b020290202d020240202d020240202d0202c0202d02000000
010b00001f055000001a055000001f055000002305500000210550000000000000001f0550000000000000002205500000210550000020055000001f055000001d0551d0551c0551c0551b0551b0551805518055
011600000c0530c053246250c053000000c05324625000000c0530c053246250c053000000c05324625000000c0530c053246250c053000000c05324625000000c0530c053246250c053000000c0532462500000
011600001f042000001a04223052210521f0521d0521a052190521905119051180521805118051220522105100000000000000000000000000000000000000000000000000000000000000000000000000000000
01160000000000000000000000000000000000000000000019220192200000000000192201922000000000001a1251c1251d1251c1251a1251c1251d1251c125211251a125211251a1251f1251a1251f1251a125
01160000130551f0552b0512b0532b0511805100000000002b0552b05500000000002b0552b05500000000001d0651d065000000000019065190651d0611c0611a0651a065000001906519065000000000000000
010600000761300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001f15300000241530000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700001f55424552000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800000144500434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000362402611026210b53100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011200000000000000000000000000000000000000000000000000000000000000001314413131131211213112131121311213111121111211112111121111111111111111111111111500000000000000000000
0112000030515000002651500000185151f5111f5111f5111f5110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0112000018155000000e1550000000155071410713107121071110711107111071110711107111071110711107111071110711107111071110711107115000000000000000000000000000000000000000000000
011400001a045000001f042000001d0451c04219045000001a041000001a0241a0211a0211a0211a0250000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0114000026045000002b042000002f0452b042240450000029041000002a0442a0422a0422a0422a0420000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400000000000000246150000024615246152461500000000000000024615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000215502155021552d10002155021550000002155021550000000000021550000002155021550000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000c1550c1550c1552d1000c1550c155000000c1550c15500000000000c155000000c1550c1550000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00 00010744
00 00020844
00 03010705
00 03020806
02 04424344
01 0a090b0c
00 0e0d0b0f
00 11121314
02 41424310
02 01424344
04 1a1b1c44
04 1d1e1f44
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
00 41424344
00 41424344
00 41424344

