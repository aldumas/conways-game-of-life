# frozen_string_literal: true

class Cell
  attr_reader :x, :y

  def initialize(x, y, world:)
    @x, @y = x, y
    @world = world
  end

  def coords
    [x, y]
  end

  def live_neighbors
    neighbors.select(&:alive?)
  end

  def dead_neighbors
    neighbors.reject(&:alive?)
  end

  def alive?
    world.alive_at? x, y
  end

  private

  attr_reader :world

  def neighbors
    [
      [x - 1, y + 1],
      [x,     y + 1],
      [x + 1, y + 1],
      [x - 1, y    ],
      # skip cell, itself
      [x + 1, y    ],
      [x - 1, y - 1],
      [x,     y - 1],
      [x + 1, y - 1],
    ].map { |coords| copy_with(coords) }
  end

  def copy_with(coords)
    self.class.new(*coords, world: world)
  end
end
