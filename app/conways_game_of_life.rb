# frozen_string_literal: true

require_relative 'serializable'
require_relative 'world'

class ConwaysGameOfLife
  include Serializable

  def initialize(world:, init_live_cells: [])
    @world = world
    @world.update(init_live_cells)
  end

  def generate
    alive_coords = []

    world.live_cells.each { |cell| alive_coords << cell.coords if [2, 3].include? cell.live_neighbors.size }
    world.dead_cells_bordering_life.each { |cell| alive_coords << cell.coords if 3 == cell.live_neighbors.size }

    world.update(alive_coords)
  end

  def serialize
    {world: world.serialize}
  end

  private

  attr_reader :world
end
