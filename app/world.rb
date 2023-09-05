# frozen_string_literal: true

require_relative 'serializable'
require_relative 'cell'

class World
  include Serializable

  def initialize(width:, height:, init: [])
    @width, @height = width, height
    update(init)
  end

  def live_cells
    living.flat_map { |col, rows| [col].product(rows.keys) }
          .map { |coords| Cell.new(*coords, world: self) }
  end

  # Dead cells that are adjacent to at least 1 live cell
  def dead_cells_bordering_life
    live_cells.flat_map(&:dead_neighbors).uniq(&:coords)
  end

  def update(alive_coords)
    @living = Hash.new { |hash, key| hash[key] = {} }

    # coords are normalized to wrap at world edges
    alive_coords.each { |x, y| @living[normal_x(x)][normal_y(y)] = true }
  end

  def alive_at?(x, y)
    !!living.dig(normal_x(x), normal_y(y))
  end

  def serialize
    {width: width, height: height, living: living.serialize}
  end

  private

  attr_reader :living, :width, :height

  def normal_x(x)
    x % width
  end

  def normal_y(y)
    y % height
  end
end
