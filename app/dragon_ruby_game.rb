# frozen_string_literal: true

require_relative 'serializable'
require_relative 'conways_game_of_life'
require_relative 'world'

class DragonRubyGame
  include Serializable

  attr_gtk

  SIZE = 10
  GENERATIONS_PER_SECOND = 10 # max 60
  TICKS_PER_GENERATION = (60.0 / GENERATIONS_PER_SECOND).ceil
  GLIDER = [[20, 65], [20, 64], [20, 63], [19, 63], [18, 64]]

  def initialize(pixels_x, pixels_y)
    @world = World.new(width: dimension(pixels_x), height: dimension(pixels_y), init: GLIDER)
    @game = ConwaysGameOfLife.new(world: @world)
  end

  def dimension(pixels)
    (pixels / SIZE.to_f).floor
  end

  def update
    game.generate(1) unless wait
  end

  def render
    render_background
    render_cells

    render_framerate
  end

  def serialize
    {game: game, world: world}
  end

  private

  attr_reader :game, :world

  def wait
    state.tick_count % TICKS_PER_GENERATION != 0
  end

  def render_background
    outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
  end

  def render_cells
    outputs.solids << world.live_cells.map(&:coords).map { |x, y| [x * SIZE, y * SIZE, SIZE, SIZE] }
  end

  def render_framerate
    outputs.debug << {
      x: (grid.right - grid.left) / 2,
      y: 0,
      text: "Framerate: #{gtk.current_framerate}",
      alignment_enum: 1,
      vertical_alignment_enum: 0
    }.label!
  end
end
