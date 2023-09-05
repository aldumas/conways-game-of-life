# frozen_string_literal: true

module Serializable
  def serialize
    {}
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end
