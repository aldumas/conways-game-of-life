# frozen_string_literal: true

require_relative 'conways_game_of_life'

SIZE = 10
GENERATIONS_PER_SECOND = 10 # max 60
TICKS_PER_GENERATION = (60.0 / GENERATIONS_PER_SECOND).ceil

GLIDER = [[20, 65], [20, 64], [20, 63], [19, 63], [18, 64]]

def tick(args)
  world = args.state.world ||= World.new(width: world_width, height: world_height, init: GLIDER)
  game = args.state.game ||= ConwaysGameOfLife.new(world: world)

  game.generate(1) unless wait(args)

  render_background args
  render_cells args, world.live_cells.map(&:coords)

  render_framerate args
end

def wait(args)
  args.state.tick_count % TICKS_PER_GENERATION != 0
end

def render_background(args)
  args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
end

def render_cells(args, live_cells)
  args.outputs.solids << live_cells.map { |x, y| [x * SIZE, y * SIZE, SIZE, SIZE] }
end

def render_framerate(args)
  args.outputs.debug << {
    x: (grid.right - grid.left) / 2,
    y: 0,
    text: "Framerate: #{args.gtk.current_framerate}",
    alignment_enum: 1,
    vertical_alignment_enum: 0
  }.label!
end

def world_width
  ((grid.right - grid.left) / SIZE).floor
end

def grid
  $gtk.args.grid
end

def world_height
  ((grid.top - grid.bottom) / SIZE).floor
end

$gtk.reset
