# frozen_string_literal: true

require_relative 'dragon_ruby_game'

def tick(args)
  game = args.state.game ||= DragonRubyGame.new(args.grid.right, args.grid.top)
  game.args = args

  game.update
  game.render
end

$gtk.reset
