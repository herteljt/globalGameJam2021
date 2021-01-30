-- global data. declared here, initialized in love.load
assets = {
   images = {
      background = nil,
      player = nil,
      obstacle = nil,
   },
   fonts = {
      regular = nil,
      header = nil,
   }
}

world_data = {
   grid = {
      width = 16,
      height = 9,
      border = 0,
   },
}

 -- Keeping track of keyboard state. If key is not pressed, state is false.
keyState = {
  up = {
    pressed = false,
    enabled = true
  },
  down = {
    pressed = false,
    enabled = true
  },
  left = {
    pressed = false,
    enabled = true
  },
  right = {
    pressed = false,
    enabled = true
  },
  space = {
    pressed = false,
    enabled = true
  },
  one = {
    pressed = false,
    enabled = true
  },
  two = {
    pressed = false,
    enabled = true
  },
  three = {
    pressed = false,
    enabled = true
  },
  four = {
    pressed = false,
    enabled = true
  },
  five = {
    pressed = false,
    enabled = true
  },
}

-- initialized at game launch
function love.load()
   print("Loading game...")


  -- player
  player = {}
    player.x = 4
    player.y = 3
    player.width = 1
    player.height = 1
    player.bullets = {}
    player.step = player.width
    player.speed = 1
    player.score = 0


   -- images
   assets.images.background = love.graphics.newImage("graphics/background.png")
   assets.images.player = love.graphics.newImage("graphics/spaceship_placeholder.png")
   assets.images.obstacle = love.graphics.newImage("graphics/obstacle_placeholder.png")

   -- fonts
   assets.fonts.regular = love.graphics.newFont("fonts/pixeboy.ttf", 28, "none")
   assets.fonts.header = love.graphics.newFont("fonts/pixeboy.ttf", 56, "none")

   -- sounds

   print("Game loaded! Let's go.")
end


-- runs continuously. logic and game state updates go here
function love.update()
   -- print("spamming the console log XD")

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
       if player.x < world_data.grid.border then
         player.x = world_data.grid.border
       end

       if player.x > world_data.grid.width - player.width - world_data.grid.border then
         player.x = world_data.grid.width - player.width - world_data.grid.border
       end

       if player.y < world_data.grid.border then
         player.y = world_data.grid.border
       end

       if player.y > world_data.grid.height - player.height - world_data.grid.border then
         player.y = world_data.grid.height - player.height - world_data.grid.border
       end



        -- Checking that I can enabled/disable keys. Using space to disable up
        if love.keyboard.isDown('space') and keyState.space.pressed == false then
          keyState.up.enabled = not keyState.up.enabled
          keyState.space.pressed = true
          print("Up Enabled: "..(keyState.up.enabled and 'TRUE' or 'FALSE'))
--[[
              if keyState.up.enabled == true then
                keyState.up.enabled = false
                keyState.space.pressed = true
                print("DISABLED")
              else
                keyState.up.enabled = true
                keyState.space.pressed = true
                print("UP ON")
              end
              ]]--
        end


       -- end program
           if love.keyboard.isDown('escape') then
              love.event.quit()
           end

       -- reset program
           if love.keyboard.isDown('r') then
              love.event.quit("restart")
           end


end


-- runs continuously; this is the only place draw calls will work
function love.draw()
   love.graphics.draw(assets.images.background, 0, 0)
   print_normal("Global Game Jam let's go!!", 12, 18)
   print_header("GGJ 2021", 400, 300)
   draw_in_grid(assets.images.player, player.x, player.y)
   draw_in_grid(assets.images.obstacle, 1, 1)
   draw_in_grid(assets.images.obstacle, 13, 4)
   draw_in_grid(assets.images.obstacle, 13, 5)
   draw_in_grid(assets.images.obstacle, 12, 6)
end


-- helpers for rendering text to screen at a pixel position
function print_normal(text, x_pos, y_pos)
   love.graphics.print(text, assets.fonts.regular, x_pos, y_pos, 0, 1, 1)
end

function print_header(text, x_pos, y_pos)
   love.graphics.print(text, assets.fonts.header, x_pos, y_pos, 0, 1, 1)
end


-- render an image at a grid position (grid is 0-indexed, origin is top left and increases right and down)
function draw_in_grid(asset, grid_x, grid_y)
   local x, y = grid_coords_to_pixels(grid_x, grid_y)
   love.graphics.draw(asset, x, y)
end


-- convert play area grid coords to pixel space
-- hard-coding 1024x768 play window, since this is a game jam and there are no rules
function grid_coords_to_pixels(grid_x, grid_y)
   if (grid_x > world_data.grid.width - 1
       or grid_x < 0
       or grid_y > world_data.grid.height - 1
       or grid_y < 0) then
      print("ERROR: tried to compute grid coords out of bounds")
      return -1, -1
   end

   local top_of_grid = 3 * 64
   local left_of_grid = 0
   local right_of_grid = world_data.grid.width * 64
   local bottom_of_grid = world_data.grid.height * 64

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
   if key == "5" then
      text = "Five  -- pressed!"
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
   if key == "5" then
      text = "Five  -- released!"
      keyState.five.pressed = false
   end
   print(text) --Remove comment to debug keypress
end
