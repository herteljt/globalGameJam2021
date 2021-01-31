require "./data"
require "./dialogue"
require "./levels"


-- initialized at game launch
function love.load()
  print("Loading game...")

  waiting = true
  waitingTimer = 10
  numberObstacles = 16

  assets.obstacle = {}



  --[[
  -- obstacles
  assets.obstacle = {0, 1, 2, 53, 68, 109, 141}
  numberObstacles = #assets.obstacle -- get size
  for i, v in ipairs(assets.obstacle) do end -- iterate
  ]]--


  -- Build levels
  -- randomly pick player coordinates within specified window
  -- randomly pick goal coordinates within specified window
  -- place number of obstacles randomly on the board.

  -- player
  player.x = love.math.random(0,5)
  player.y = love.math.random(0,5)
  player.width = 1
  player.height = 1
  player.speed = 1
  player.score = 0
  player.step = 1
  player.facingIndex = 0 -- Using NSEW with 0 = E, 1 = N, 2 = W, 3 = S

  -- goal
  goal.x = love.math.random(5,15)
  goal.y = love.math.random(3,8)
  goal.visibility = 0 --initially make it hidden

  -- command bar
  commandBar.index = 1
  commandBar.image[1]= love.graphics.newImage("graphics/transparent_placeholder.png")
  commandBar.image[2]= love.graphics.newImage("graphics/transparent_placeholder.png")
  commandBar.image[3]= love.graphics.newImage("graphics/transparent_placeholder.png")
  commandBar.image[4]= love.graphics.newImage("graphics/transparent_placeholder.png")
  commandBar.image[5]= love.graphics.newImage("graphics/transparent_placeholder.png")


  -- world data
  worldData.grid.width = 16
  worldData.grid.height = 9
  worldData.grid.border = 0


  -- player
  assets.player.right = love.graphics.newImage("graphics/player_right.png")
  assets.player.down = love.graphics.newImage("graphics/player_down.png")
  assets.player.left = love.graphics.newImage("graphics/player_left.png")
  assets.player.up = love.graphics.newImage("graphics/player_up.png")


  -- images
  assets.images.background = love.graphics.newImage("graphics/background.png")
  assets.images.obstacle = love.graphics.newImage("graphics/obstacle_placeholder.png")
  assets.images.fake_avatar = love.graphics.newImage("graphics/avatar_placeholder.png")
  assets.images.forward = love.graphics.newImage("graphics/forward_placeholder.png")
  assets.images.left = love.graphics.newImage("graphics/left_placeholder.png")
  assets.images.right = love.graphics.newImage("graphics/right_placeholder.png")
  assets.images.blank = love.graphics.newImage("graphics/transparent_placeholder.png")
  assets.images.z85000 = love.graphics.newImage("graphics/z85000.png")
  assets.images.biff_enthusiastic = love.graphics.newImage("graphics/biff_enthusiastic.png")
  assets.images.biff_tired = love.graphics.newImage("graphics/biff_tired.png")
  assets.images.bored_teenager = love.graphics.newImage("graphics/teenager.png")
  assets.images.alien_excited = love.graphics.newImage("graphics/alien_excited.png")
  assets.images.alien_disappointed = love.graphics.newImage("graphics/alien_disappointed.png")
  assets.images.goal = love.graphics.newImage("graphics/goal_placeholder.png")

  -- fonts
  assets.fonts.regular = love.graphics.newFont("fonts/pixeboy.ttf", 28, "none")
  assets.fonts.header = love.graphics.newFont("fonts/pixeboy.ttf", 56, "none")
  assets.fonts.dialogue = love.graphics.newFont("fonts/pixeboy.ttf", 22, "none")

  -- sounds
--[[
  assets.sounds.level = love.audio.newSource("/sounds/chill.mp3", "static")
  assets.sounds.level:setLooping(true)
  assets.sounds.level:setVolume(.05)
  assets.sounds.level:play()
]]--

  -- Build world
  buildLevel(0,141,numberObstacles)

  print("Game loaded! Let's go.")
end


-- runs continuously. logic and game state updates go here
function love.update(dt)

  -- Debug mode enables W/A/S/D movement and space rotates clockwise
  if worldData.state == enums.game_states.DEBUG then
    if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) and keyState.right.pressed == false then
      player.x = player.x + player.step
      keyState.right.pressed = true
    elseif (love.keyboard.isDown("left") or love.keyboard.isDown("a")) and keyState.left.pressed == false then
      player.x = player.x - player.step
      keyState.left.pressed = true
    end
    if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and keyState.up.pressed == false and keyState.up.enabled == true then
      player.y = player.y - player.step
      keyState.up.pressed = true
    elseif (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and keyState.down.pressed == false then
      player.y = player.y + player.step
      keyState.down.pressed = true
    end

    -- Using space to debug facing
    if love.keyboard.isDown('space') and keyState.space.pressed == false then
      player.facingIndex = (player.facingIndex + 1)%4
      keyState.space.pressed = true
      print("Turn clockwise")
      print("Player Facing: "..player.facingIndex)
      print(player.facingIndex%4)
      print("Player X: "..player.x)
      print("Player Y: "..player.y)
    end
  end


  if worldData.state == enums.game_states.RUNNING_COMMAND_QUEUE then
    commandBar.queue_timer = commandBar.queue_timer + dt

    -- run a command from commandBar every 1 second
    if commandBar.queue_timer > 1 then
      commandBar.queue_timer = 0
      local idx = commandBar.index

      if commandBar.command[idx]==1 and player.facingIndex == 0 then
        checkCollisions(player.x+player.step,player.y,assets.obstacle, numberObstacles)
        player.x = player.x + player.step
        commandBar.command[idx] = 0
        commandBar.image[idx] = assets.images.blank
        checkGoal(player.x, player.y, goal.x, goal.y)
      elseif commandBar.command[idx]==1 and player.facingIndex == 1 then
        checkCollisions(player.x,player.y+player.step,assets.obstacle, numberObstacles)
        player.y = player.y + player.step
        commandBar.command[idx] = 0
        commandBar.image[idx] = assets.images.blank
        checkGoal(player.x, player.y, goal.x, goal.y)
      elseif commandBar.command[idx]==1 and player.facingIndex == 2 then
        checkCollisions(player.x-player.step,player.y,assets.obstacle, numberObstacles)
        player.x = player.x - player.step
        commandBar.command[idx] = 0
        commandBar.image[idx] = assets.images.blank
        checkGoal(player.x, player.y, goal.x, goal.y)
      elseif commandBar.command[idx]==1 and player.facingIndex == 3 then
        checkCollisions(player.x,player.y-player.step,assets.obstacle, numberObstacles)
        player.y = player.y - player.step
        commandBar.command[idx] = 0
        commandBar.image[idx] = assets.images.blank
        checkGoal(player.x, player.y, goal.x, goal.y)
      end

      if commandBar.command[idx]==2 then
        player.facingIndex = (player.facingIndex + 3)%4
        print(player.facingIndex)
        commandBar.command[idx] = 0
        commandBar.image[idx] = assets.images.blank
      end
      if commandBar.command[idx]==3 then
        player.facingIndex = (player.facingIndex + 1)%4
        print(player.facingIndex)
        commandBar.command[idx] = 0
        commandBar.image[idx] = assets.images.blank
      end

      -- if we're at the end of the command queue, return to normal gameplay
      commandBar.index = idx + 1
      if commandBar.index > 5 then
        commandBar.index = 1
        worldData.state = enums.game_states.MAIN_ACTION
      end
    end
  end


  -- Prevent player from going offscreen
  if player.x < worldData.grid.border then
    player.x = worldData.grid.border
  end

  if player.x > worldData.grid.width - player.width - worldData.grid.border then
    player.x = worldData.grid.width - player.width - worldData.grid.border
  end

  if player.y < worldData.grid.border then
    player.y = worldData.grid.border
  end

  if player.y > worldData.grid.height - player.height - worldData.grid.border then
    player.y = worldData.grid.height - player.height - worldData.grid.border
  end


  if worldData.state == enums.game_states.MAIN_ACTION then
    if love.keyboard.isDown('return') and keyState.enter.pressed == false then
      keyState.enter.pressed = true
      print("Running commands...")
      commandBar.index = 1
      commandBar.queue_timer = 100 -- start with very high number so we pop first action immediately
      worldData.state = enums.game_states.RUNNING_COMMAND_QUEUE
    end


    -- Enable command input
    if love.keyboard.isDown('backspace') and keyState.backspace.pressed == false then
      commandBar.command[commandBar.index-1] = 0   -- Set the value of the current command queue position to 0
      commandBar.image[commandBar.index-1] = assets.images.blank
      if commandBar.index <= 1 then
        commandBar.index = 1
      else
        commandBar.index = commandBar.index - 1
      end
      keyState.backspace.pressed = true
    end


    -- Command Bar Queue Code
    if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and keyState.up.pressed == false then
      commandBar.command[commandBar.index] = 1   -- Set the value of the current command queue position to 1
      commandBar.image[commandBar.index] = assets.images.forward
      if commandBar.index >= 5 then
        commandBar.index = 6
      else
        commandBar.index = commandBar.index + 1 -- shift the command question position
      end
      keyState.up.pressed = true
    end

    if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and keyState.left.pressed == false then
      commandBar.command[commandBar.index] = 2   -- Set the value of the current command queue position to 1
      commandBar.image[commandBar.index] = assets.images.left
      if commandBar.index >= 5 then
        commandBar.index = 6
      else
        commandBar.index = commandBar.index + 1 -- shift the command question position
      end
      keyState.left.pressed = true
    end

    if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) and keyState.right.pressed == false then
      commandBar.command[commandBar.index] = 3   -- Set the value of the current command queue position to 1
      commandBar.image[commandBar.index] = assets.images.right
      if commandBar.index >= 5 then
        commandBar.index = 6
      else
        commandBar.index = commandBar.index + 1 -- shift the command question position
      end
      keyState.right.pressed = true
    end
  end




--[[
  -- Original Index logic. Saving for posterity
  if love.keyboard.isDown('space') and keyState.space.pressed == false then
    player.facing = (player.facing + 1)%4
    keyState.space.pressed = true
    player.x = player.x + math.sin(player.facing*math.pi/2)
    player.y = player.y - math.cos(player.facing*math.pi/2)
    print("Turn clockwise")
    print("Player Facing: "..player.facing)
    print(player.facing%4)
    print("Player X: "..player.x)
    print("Player Y: "..player.y)
  end


  ]]--

  if love.keyboard.isDown('lalt') and keyState.alt.pressed == false then
    if worldData.state == enums.game_states.DIALOGUE or worldData.state == enums.game_states.MAIN_ACTION then
      worldData.state = enums.game_states.DEBUG
      print("DEBUG MODE. W/A/S/D enabled")
    elseif worldData.state == enums.game_states.DEBUG then
      worldData.state = enums.game_states.MAIN_ACTION
      print("MAIN ACTION MODE. W/A/S/D disabled")
    end
    keyState.alt.pressed = true
  end

  -- end program
  if love.keyboard.isDown('escape') then
    love.event.quit()
  end

  -- reset program
  if love.keyboard.isDown('r') then
    love.event.quit("restart")
  end

  if not love.keyboard.isDown('p') then
    keyState.p.pressed = false
  end

  if worldData.state == enums.game_states.DIALOGUE then
    local full_len = string.len(worldData.current_dialogue.text)
    local chars_per_second = 45
    local len_to_print = chars_per_second * worldData.current_dialogue.time_since_started_printing
    worldData.current_dialogue.len_to_print = len_to_print
    worldData.current_dialogue.time_since_started_printing = dt + worldData.current_dialogue.time_since_started_printing

    if full_len > len_to_print then
      worldData.cursor_blink_time = 5000
    else
      worldData.cursor_blink_time = worldData.cursor_blink_time + dt
      if worldData.cursor_blink_time > 1 then
        worldData.cursor_blink_time = 0
      end
    end
  end

  if love.keyboard.isDown('p')
    and not keyState.p.pressed
    and worldData.state == enums.game_states.MAIN_ACTION then
    -- TODO: wrap all of game loop in game state check to make sure we're handling input right
    keyState.p.pressed = true
    display_dialogue(dialogue.introduction)
  end
  if love.keyboard.isDown('p')
    and worldData.state == enums.game_states.DIALOGUE
    and not keyState.p.pressed then
    keyState.p.pressed = true
    advance_dialogue()
  end
end


-- runs continuously; this is the only place draw calls will work
function love.draw()
  love.graphics.draw(assets.images.background, 0, 0)

  local prev_r, prev_g, prev_b, prev_a = love.graphics.getColor()
  love.graphics.setColor(0.1, 0.1, 0.1, 1)
  print_normal("z85000", 40, 40)
  love.graphics.setColor(1, 1, 1, 1)
  print_normal("z85000", 40, 42)
  love.graphics.setColor(prev_r, prev_g, prev_b, prev_a)

  if commandBar.index > 5 then
    love.graphics.printf("Command Queue Full. Execute commands(enter) or delete(backspace).", assets.fonts.dialogue, 680, 65, 320)
  end

--  draw obstacles
  for i = 1,numberObstacles do
    draw_in_grid(assets.images.obstacle,math.floor(assets.obstacle[i]%16),math.floor(assets.obstacle[i]/16))
  end


  if player.facingIndex == 0 then
    draw_in_grid(assets.player.right, player.x, player.y)
  elseif player.facingIndex == 1 then
    draw_in_grid(assets.player.down, player.x, player.y)
  elseif player.facingIndex == 2 then
    draw_in_grid(assets.player.left, player.x, player.y)
  elseif player.facingIndex == 3 then
    draw_in_grid(assets.player.up, player.x, player.y)
  end

  -- Draw Goal
  if goal.visibility == 0 then
    draw_in_grid(assets.images.goal, goal.x, goal.y)
  end


  -- Draw Command Bar
  love.graphics.draw(commandBar.image[1], 69, 108, 0, 1, 1, 0, 0, 0, 0)
  love.graphics.draw(commandBar.image[2], 132, 108, 0, 1, 1, 0, 0, 0, 0)
  love.graphics.draw(commandBar.image[3], 195, 108, 0, 1, 1, 0, 0, 0, 0)
  love.graphics.draw(commandBar.image[4], 258, 108, 0, 1, 1, 0, 0, 0, 0)
  love.graphics.draw(commandBar.image[5], 321, 108, 0, 1, 1, 0, 0, 0, 0)

  -- love.graphics.draw(assets.images.player, 300, 400, player.facing)

  if worldData.state == enums.game_states.DIALOGUE then
    local prev_r, prev_g, prev_b, prev_a = love.graphics.getColor()

    -- overlay to dim the play grid while dialogue is happening
    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle('fill', 0, 64 * 3, 1024, 768)
    -- render currently set avatar, name, and text
    if worldData.current_dialogue then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(assets.images[worldData.current_dialogue.avatar], 537, 33)
      love.graphics.setColor(0, 0.8, 0, 1)
      print_name(worldData.current_dialogue.name)
      local substr = string.sub(worldData.current_dialogue.text, 1, worldData.current_dialogue.len_to_print)
      print_dialogue_text(substr)
      print_dialogue_continue_caret()
    end

    love.graphics.setColor(prev_r, prev_g, prev_b, prev_a)
  end

  -- overlay to dim the play grid when exploded
    if worldData.state == enums.game_states.EXPLODED then
      love.graphics.setColor(150, 0, 0, 0.5)
      love.graphics.rectangle('fill', 0, 64 * 3, 1024, 768)
      love.graphics.printf("EXPLOSION!!", assets.fonts.dialogue, 680, 65, 320)
    end

end



-- helpers for rendering text to screen at a pixel position
function print_normal(text, x_pos, y_pos)
  love.graphics.print(text, assets.fonts.regular, x_pos, y_pos, 0, 1, 1)
end

function print_header(text, x_pos, y_pos)
  love.graphics.print(text, assets.fonts.header, x_pos, y_pos, 0, 1, 1)
end

function print_name(name)
  love.graphics.print(name, assets.fonts.regular, 680, 33)
end

function print_dialogue_text(text)
  love.graphics.printf(text, assets.fonts.dialogue, 680, 65, 320)
end

function print_dialogue_continue_caret()
  if worldData.cursor_blink_time < 0.5 then
    love.graphics.print(">", assets.fonts.regular, 975, 145)
  end
end


-- render an image at a grid position (grid is 0-indexed, origin is top left and increases right and down)
--[[
  function draw_in_grid(asset, grid_x, grid_y)
  local x, y = grid_coords_to_pixels(grid_x, grid_y)
  love.graphics.draw(asset, x, y)
  end
]]--

function draw_in_grid(asset, grid_x, grid_y)
  local x, y = grid_coords_to_pixels(grid_x, grid_y)
  love.graphics.draw(asset, x, y)
end


-- convert play area grid coords to pixel space
-- hard-coding 1024x768 play window, since this is a game jam and there are no rules
function grid_coords_to_pixels(grid_x, grid_y)
  if (grid_x > worldData.grid.width - 1
      or grid_x < 0
      or grid_y > worldData.grid.height - 1
      or grid_y < 0) then
    print("ERROR: tried to compute grid coords out of bounds")
    return -1, -1
  end

  local top_of_grid = 3 * 64
  local left_of_grid = 0
  local right_of_grid = worldData.grid.width * 64
  local bottom_of_grid = worldData.grid.height * 64

  local pixels_x = grid_x * 64 + left_of_grid
  local pixels_y = grid_y * 64 + top_of_grid

  return pixels_x, pixels_y
end

-- Draw map

function drawMap()
   for i = 1, 9 do
      for j = 1, 16 do

         love.graphics.draw(assets.map[i][j],0,0)
      end
   end
end




--Functions to track key pressing
function love.keypressed( key )
  if key == "d" or key =="right" then
    text = "Right  -- pressed!"
  end
  if key == "a" or key =="left" then
    text = "Left  -- pressed!"
  end
  if key == "w" or key =="up" then
    text = "Up  -- pressed!"
  end
  if key == "s" or key =="down" then
    text = "Down  -- pressed!"
  end
  if key == "space" then
    text = "Space  -- pressed!"
  end
  if key == "1" then
    text = "One  -- pressed!"
  end
  if key == "2" then
    text = "Two  -- pressed!"
  end
  if key == "3" then
    text = "Three  -- pressed!"
  end
  if key == "4" then
    text = "Four  -- pressed!"
  end
  if key == "backspace" then
    text = "Backspace  -- pressed!"
  end
  if key == "lalt" then
    text = "Alt  -- pressed!"
  end
  if key == "return" then
    text = "Enter  -- pressed!"
  end
  print(text) --Remove comment to debug keypress
end


function love.keyreleased( key )
  if key == "d" or key =="right" then
    text = "Right  -- released!"
    keyState.right.pressed = false
  end
  if key == "a" or key =="left" then
    text = "Left  -- released!"
    keyState.left.pressed = false
  end
  if key == "w" or key =="up" then
    text = "Up  -- released!"
    keyState.up.pressed = false
  end
  if key == "s" or key =="down" then
    text = "Down  -- released!"
    keyState.down.pressed = false
  end
  if key == "space" then
    text = "Space  -- released!"
    keyState.space.pressed = false
  end
  if key == "1" then
    text = "One  -- released!"
    keyState.one.pressed = false
  end
  if key == "2" then
    text = "Two  -- released!"
    keyState.two.pressed = false
  end
  if key == "3" then
    text = "Three  -- released!"
    keyState.three.pressed = false
  end
  if key == "4" then
    text = "Four  -- released!"
    keyState.four.pressed = false
  end
  if key == "backspace" then
    text = "Backspace  -- released!"
    keyState.backspace.pressed = false
  end
  if key == "lalt" then
    text = "Alt  -- released!"
    keyState.alt.pressed = false
  end
  if key == "return" then
    text = "Enter  -- released!"
    keyState.enter.pressed = false
  end
  --   print(text) --Remove comment to debug keypress
end


function display_dialogue(dialogue_chunk)
  worldData.state = enums.game_states.DIALOGUE
  worldData.current_dialogue.full_chunk = dialogue_chunk
  worldData.current_dialogue.chunk_index = 0
  local size = 0
  for i,x in ipairs(dialogue_chunk) do
    size = size + 1
  end
  worldData.current_dialogue.chunk_length = size
  advance_dialogue()
end

function advance_dialogue()
  local idx = worldData.current_dialogue.chunk_index + 1
  local dia = worldData.current_dialogue.full_chunk[idx]

  if idx > worldData.current_dialogue.chunk_length then
    worldData.state = enums.game_states.MAIN_ACTION
    return
  end

  worldData.current_dialogue.name = dia.name
  worldData.current_dialogue.text = dia.text
  worldData.current_dialogue.avatar = dia.avatar
  worldData.current_dialogue.time_since_started_printing = 0
  worldData.current_dialogue.len_to_print = 0

  worldData.current_dialogue.chunk_index = idx
end

-- Build Level

function buildLevel (start, stop, numberObstacles)
  player.gridLocation = player.y*16 + player.x
  goal.gridLocation = goal.y*16 + goal.x
  print("Player grid location"..player.gridLocation)
  --player.gridLocation = love.math.random(start, stop)

  for i = 1,numberObstacles do
    local obstacle = love.math.random(start, stop)
    if obstacle > player.gridLocation or obstacle < player.gridLocation then
        assets.obstacle[i] = obstacle
    else
       print("Cannot place obstacle. Player collision conflict.")
       assets.obstacle[i] = 141
    end
  end

end


-- Check checkCollisions
function checkCollisions (x, y, obstacle, number)
  local playerLocation = (y)*16 + x
  print("Player Location: "..playerLocation)
  for i = 1, number do
    if playerLocation == obstacle[i] then
      print("COLLISION at "..obstacle[i])
      worldData.state = enums.game_states.EXPLODED
    end
  end
end

-- Check Goal
function checkGoal (playerx, playery, goalx, goaly)
  if math.abs(playerx - goalx) <= 4 and math.abs(playery-goaly) <= 4 then
    if playerx == goalx and playery==goaly then
      print("You win!")
      worldData.state = enums.game_states.WIN
    else
      goal.visibility = 1
    end
  end
end
