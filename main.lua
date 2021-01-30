require "./data"
require "./dialogue"


-- initialized at game launch
function love.load()
  print("Loading game...")

  waiting = true
  waitingTimer = 10

  -- player
  player.x = 4
  player.y = 3
  player.width = 1
  player.height = 1
  player.speed = 1
  player.score = 0
  player.step = 1
  player.facingIndex = 0 -- Using NSEW with 0 = E, 1 = N, 2 = W, 3 = S

  -- command bar
  commandBar.index = 1
  commandBar.image[1]= love.graphics.newImage("graphics/blank_placeholder.png")
  commandBar.image[2]= love.graphics.newImage("graphics/blank_placeholder.png")
  commandBar.image[3]= love.graphics.newImage("graphics/blank_placeholder.png")
  commandBar.image[4]= love.graphics.newImage("graphics/blank_placeholder.png")
  commandBar.image[5]= love.graphics.newImage("graphics/blank_placeholder.png")


  -- world data
  worldData.grid.width = 16
  worldData.grid.height = 9
  worldData.grid.border = 0

  -- images
  assets.images.background = love.graphics.newImage("graphics/background.png")
  assets.player.right = love.graphics.newImage("graphics/right_facing_placeholder.png")
  assets.player.down = love.graphics.newImage("graphics/down_facing_placeholder.png")
  assets.player.left = love.graphics.newImage("graphics/left_facing_placeholder.png")
  assets.player.up = love.graphics.newImage("graphics/up_facing_placeholder.png")
  assets.images.obstacle = love.graphics.newImage("graphics/obstacle_placeholder.png")
  assets.images.fake_avatar = love.graphics.newImage("graphics/avatar_placeholder.png")
  assets.images.forward = love.graphics.newImage("graphics/forward_placeholder.png")
  assets.images.left = love.graphics.newImage("graphics/left_placeholder.png")
  assets.images.right = love.graphics.newImage("graphics/right_placeholder.png")
  assets.images.blank = love.graphics.newImage("graphics/blank_placeholder.png")

  -- fonts
  assets.fonts.regular = love.graphics.newFont("fonts/pixeboy.ttf", 28, "none")
  assets.fonts.header = love.graphics.newFont("fonts/pixeboy.ttf", 56, "none")
  assets.fonts.dialogue = love.graphics.newFont("fonts/pixeboy.ttf", 22, "none")

  -- sounds

  print("Game loaded! Let's go.")
end


-- runs continuously. logic and game state updates go here
function love.update(dt)
  -- Player movement
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
    if love.keyboard.isDown('4') and keyState.four.pressed == false then
      keyState.four.pressed = true
      print("Running commands...")
      for i = 1, 5 do
        if commandBar.command[i]==1 and player.facingIndex == 0 then
          player.x = player.x + player.step
          commandBar.command[i] = 0
          commandBar.image[i] = assets.images.blank
        elseif commandBar.command[i]==1 and player.facingIndex == 1 then
          player.y = player.y + player.step
          commandBar.command[i] = 0
          commandBar.image[i] = assets.images.blank
        elseif commandBar.command[i]==1 and player.facingIndex == 2 then
           player.x = player.x - player.step
           commandBar.command[i] = 0
           commandBar.image[i] = assets.images.blank
        elseif commandBar.command[i]==1 and player.facingIndex == 3 then
           player.y = player.y + player.step
           commandBar.command[i] = 0
           commandBar.image[i] = assets.images.blank
        end

        if commandBar.command[i]==2 then
          player.facingIndex = (player.facingIndex + 3)%4
          print(player.facingIndex)
          commandBar.command[i] = 0
          commandBar.image[i] = assets.images.blank
        end
        if commandBar.command[i]==3 then
          player.facingIndex = (player.facingIndex + 1)%4
          print(player.facingIndex)
          commandBar.command[i] = 0
          commandBar.image[i] = assets.images.blank
        end
        if checkCollisions() then --Check collisions

        end
      end
      commandBar.index = 1

    end


    -- Enable command input
    if love.keyboard.isDown('backspace') and keyState.backspace.pressed == false then
      commandBar.command[commandBar.index-1] = 0   -- Set the value of the current command queue position to 0
      commandBar.image[commandBar.index-1] = assets.images.blank
      commandBar.index = commandBar.index - 1
      keyState.backspace.pressed = true
    end


    -- Command Bar Queue Code
    if love.keyboard.isDown('1') and keyState.one.pressed == false then
      commandBar.command[commandBar.index] = 1   -- Set the value of the current command queue position to 1
      commandBar.image[commandBar.index] = assets.images.forward
      if commandBar.index >= 5 then
        commandBar.index = 1
      else
        commandBar.index = commandBar.index + 1 -- shift the command question position
      end
      keyState.one.pressed = true
    end

    if love.keyboard.isDown('2') and keyState.two.pressed == false then
      commandBar.command[commandBar.index] = 2   -- Set the value of the current command queue position to 1
      commandBar.image[commandBar.index] = assets.images.left
      if commandBar.index >= 5 then
        commandBar.index = 1
      else
        commandBar.index = commandBar.index + 1 -- shift the command question position
      end
      keyState.two.pressed = true
    end

    if love.keyboard.isDown('3') and keyState.three.pressed == false then
      commandBar.command[commandBar.index] = 3   -- Set the value of the current command queue position to 1
      commandBar.image[commandBar.index] = assets.images.right
      if commandBar.index >= 5 then
        commandBar.index = 1
      else
        commandBar.index = commandBar.index + 1 -- shift the command question position
      end
      keyState.three.pressed = true
    end
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


  if love.keyboard.isDown('lalt') and keyState.alt.pressed == false then
    player.facing = player.facing - 1
    keyState.alt.pressed = true
    player.x = player.x - math.cos(player.facing*math.pi/2)
    player.y = player.y - math.sin(player.facing*math.pi/2)
    print("Turn counterclockwise")
    print("Player Facing: "..player.facing)
    print("Player X: "..player.x)
    print("Player Y: "..player.y)
  end
]]--

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

  draw_in_grid(assets.images.obstacle, 1, 1, 0)
  draw_in_grid(assets.images.obstacle, 13, 4, 0)
  draw_in_grid(assets.images.obstacle, 13, 5, 0)
  draw_in_grid(assets.images.obstacle, 12, 6, 0)

  if player.facingIndex == 0 then
    draw_in_grid(assets.player.right, player.x, player.y, player.facingIndex)
  elseif player.facingIndex == 1 then
    draw_in_grid(assets.player.down, player.x, player.y, player.facingIndex)
  elseif player.facingIndex == 2 then
    draw_in_grid(assets.player.left, player.x, player.y, player.facingIndex)
  elseif player.facingIndex == 3 then
    draw_in_grid(assets.player.up, player.x, player.y, player.facingIndex)
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
      love.graphics.setColor(0, 0.8, 0, 1)
      love.graphics.draw(assets.images[worldData.current_dialogue.avatar], 537, 33)
      print_name(worldData.current_dialogue.name)
      local substr = string.sub(worldData.current_dialogue.text, 1, worldData.current_dialogue.len_to_print)
      print_dialogue_text(substr)
      print_dialogue_continue_caret()
    end

    love.graphics.setColor(prev_r, prev_g, prev_b, prev_a)
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

function draw_in_grid(asset, grid_x, grid_y, facing)
  local x, y = grid_coords_to_pixels(grid_x, grid_y)
  love.graphics.draw(asset, x, y, 0)
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

  worldData.current_dialogue.chunk_index = idx
end


-- Check checkCollisions

function checkCollisions ()


end
