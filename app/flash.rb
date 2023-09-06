# frozen_string_literal: true

require_relative 'serializable'

class Flash
  include Serializable

  SPEED_IN = 10 # pixels per tick
  SPEED_OUT = 2 # pixels per tick

  def initialize(message, left_x:, bottom_y:)
    @message = message
    @start_x = left_x
    @padding = 10
    @label = {
      text: message,
      x: left_x,
      y: bottom_y,
      alignment_enum: 0,
      vertical_alignment_enum: 0
    }
    @top = nil # set on first render
    @wait = 3 * 60 # 3 seconds
  end

  def render(args)
    @end_x ||= @start_x - @padding - args.gtk.calcstringbox(label[:text])[0]
    @top ||= args.grid.top

    unless done?
      if label[:x] > @end_x
        label[:x] = [label[:x] - SPEED_IN, @end_x].max
      elsif @wait > 0
        @wait -= 1
      else
        label[:y] += SPEED_OUT
      end

      args.outputs.labels << label
    end
  end

  def done?
    @top && label[:y] > @top
  end

  def serialize
    {
      message: @message,
      start_x: @start_x,
      padding: @padding,
      label: label,
      top: @top,
      wait: @wait
    }
  end

  private

  attr_reader :label
end
