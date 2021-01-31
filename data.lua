

-- global data. declared here, initialized in love.load
assets = {
  obstacle = {
  },
  images = {
    background = nil,
    obstacle = nil,
    fake_avatar = nil,
    forward = nil,
    left = nil,
    right = nil,
    blank = nil,
    z85000 = nil,
    biff_enthusiastic = nil,
    biff_tired = nil,
    bored_teenager = nil,
    alien_excited = nil,
    alien_disappointed = nil,
    goal = nil,
    end_credits = nil,
  },
  player ={

  },
  music = {
    state = nil,
    intro = nil,
    level = nil,
    encounter = nil,
    win = nil,
    incomingmessage = nil,
  },
  fonts = {
    regular = nil,
    header = nil,
    dialogue = nil,
  },
}

enums = {
  game_states = {
    MAIN_ACTION = 0,
    DIALOGUE = 1,
    EXPLODED = 2,
    DEBUG = 3,
    RUNNING_COMMAND_QUEUE = 4,
    WIN = 5,
  }
}

worldData = {
  state = enums.game_states.MAIN_ACTION,
  grid = {
    width = nil,
    height = nil,
    border = nil,
  },
  current_dialogue = {
    name = nil,
    avatar = nil,
    text = nil,
    time_since_started_printing = 0,
    len_to_print = 0,
    full_chunk = nil,
    chunk_index = 1,
    chunk_length = 0,
    game_mode_after_dialogue_done = enums.game_states.MAIN_ACTION,
  },
  cursor_blink_time = 0,
}


-- Command Bar variables.
commandBar = { --Note: indices start at 1 in Love2d rather than 0

  index = nil, --keeping track of which command is selected
  queue_timer = 0,  -- time in seconds since last command executed

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
  accent = {
    pressed = false,
    enabled = true
  },
  enter = {
    pressed = false,
    enabled = true
  }
}

player = {
  x = nil,
  y = nil,
  width = nil,
  height = nil,
  speed = nil,
  score = nil,
  step = nil,
  facingIndex = nil,
  gridPosition = nil, -- Location as a single number on the grid

}

goal = {
  x = nil,
  y = nil,
  gridPosition = nil, -- Location as a single number on the grid
  is_visible = false,  -- Is the goal visible
}
