# frozen_string_literal: true

require_relative 'serializable'
require_relative 'world'

class ConwaysGameOfLife
  include Serializable

  def initialize(world:)
    @world = world
  end

  def generate(n)
    n.times do
      alive_coords = []

      world.live_cells.each { |cell| alive_coords << cell.coords if [2, 3].include? cell.live_neighbors.size }
      world.dead_cells_bordering_life.each { |cell| alive_coords << cell.coords if 3 == cell.live_neighbors.size }

      world.update(alive_coords)
    end
  end

  def serialize
    {world: world.serialize}
  end

  private

  attr_reader :world
end
