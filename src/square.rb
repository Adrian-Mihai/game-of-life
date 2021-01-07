# frozen_string_literal: true

class Square
  attr_accessor :x, :y, :state

  def initialize(x, y)
    @x = x
    @y = y
    @state = 0
  end
end
