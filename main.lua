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
   },
}

-- initialized at game launch
function love.load()
   print("Loading game...")

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
end


-- runs continuously; this is the only place draw calls will work
function love.draw()
   love.graphics.draw(assets.images.background, 0, 0)
   print_normal("Global Game Jam let's go!!", 12, 18)
   print_header("GGJ 2021", 400, 300)
   draw_in_grid(assets.images.player, 4, 3)
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
