-- global data. declared here, initialized in love.load
assets = {
   images = {
      background = nil,
      player = nil,
      obstacle = nil,
      forward = nil,
      left = nil,
      right = nil,
      blank = nil,
   },
   fonts = {
      regular = nil,
      header = nil,
   }
}

worldData = {
   grid = {
      width = nil,
      height = nil,
      border = nil,
   },
}


-- Command Bar variables.
commandBar = { --Note: indices start at 1 in Love2d rather than 0

      index = nil, --keeping track of which command is selected

      command = {
        first = nil, -- 1st command
        second = nil, -- 2nd command
        third = nil, -- 3rd command
        fourth = nil, -- 4th command
        fifth = nil,  -- 5th command
        },

        image = {},
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
  backspace = {
    pressed = false,
    enabled = true
  },
}

player = {
x = nil,
y = nil,
width = nil,
height = nil,
speed = nil,
score = nil,
step = nil,
facing = nil,


}

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
    player.facing = 0 -- Using NSEW with 0 = E, 1 = N, 2 = W, 3 = S

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
   assets.images.player = love.graphics.newImage("graphics/spaceship_placeholder.png")
   assets.images.obstacle = love.graphics.newImage("graphics/obstacle_placeholder.png")
   assets.images.forward = love.graphics.newImage("graphics/forward_placeholder.png")
   assets.images.left = love.graphics.newImage("graphics/left_placeholder.png")
   assets.images.right = love.graphics.newImage("graphics/right_placeholder.png")
   assets.images.blank = love.graphics.newImage("graphics/blank_placeholder.png")



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


       -- Enable command input

      if love.keyboard.isDown('4') and keyState.four.pressed == false then
        keyState.four.pressed = true
        print("Running commands...")
        for i = 1, 5 do
          if commandBar.command[i]==1 then
            player.x = player.x + player.step
            commandBar.command[i] = 0
            commandBar.image[i] = assets.images.blank
          end
          if commandBar.command[i]==2 then
            player.y = player.y - player.step
            commandBar.command[i] = 0
            commandBar.image[i] = assets.images.blank
          end
          if commandBar.command[i]==3 then
            player.y = player.y + player.step
            commandBar.command[i] = 0
            commandBar.image[i] = assets.images.blank
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


      -- New Commnad Queue Code
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









        -- Checking that I can enabled/disable keys. Using space to disable up
        if love.keyboard.isDown('space') and keyState.space.pressed == false then
          keyState.up.enabled = not keyState.up.enabled
          keyState.space.pressed = true
          print("Up Enabled: "..(keyState.up.enabled and 'TRUE' or 'FALSE'))
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
   print_header("GGJ 2021", 400, 300)
   draw_in_grid(assets.images.player, player.x, player.y)
   draw_in_grid(assets.images.obstacle, 1, 1)
   draw_in_grid(assets.images.obstacle, 13, 4)
   draw_in_grid(assets.images.obstacle, 13, 5)
   draw_in_grid(assets.images.obstacle, 12, 6)

   -- Draw Command Bar
   love.graphics.draw(commandBar.image[1], 69, 108, 0, 1, 1, 0, 0, 0, 0)
   love.graphics.draw(commandBar.image[2], 132, 108, 0, 1, 1, 0, 0, 0, 0)
   love.graphics.draw(commandBar.image[3], 195, 108, 0, 1, 1, 0, 0, 0, 0)
   love.graphics.draw(commandBar.image[4], 258, 108, 0, 1, 1, 0, 0, 0, 0)
   love.graphics.draw(commandBar.image[5], 321, 108, 0, 1, 1, 0, 0, 0, 0)


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
--   print(text) --Remove comment to debug keypress
end
