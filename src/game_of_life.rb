# frozen_string_literal: true

require 'gosu'

require_relative 'board'

class GameOfLife < Gosu::Window
  GAME_WIDTH = ENV.fetch('GAME_WIDTH').to_i
  GAME_HEIGHT = ENV.fetch('GAME_HEIGHT').to_i

  BOARD_OFFSET_WIGHT = ENV.fetch('BOARD_OFFSET_WIDTH').to_i

  def initialize
    super(GAME_WIDTH, GAME_HEIGHT)
    self.caption = ENV.fetch('NAME', 'Game of Life')

    @font = Gosu::Font.new(25)

    @started = false
    @generation = 0
    @board = Board.new(GAME_WIDTH, GAME_HEIGHT)
  end

  def draw
    @font.draw_text("Generation: #{@generation}", BOARD_OFFSET_WIGHT, 0, 0, 1.0, 1.0, Gosu::Color::GRAY)
    @board.draw
  end

  def update
    self.caption = "#{ENV.fetch('NAME', 'Game of Life')} #{Gosu.fps} FPS"

    return unless @started

    @generation += 1
    @board.update
  end

  def button_down(id)
    case id
    when Gosu::KB_SPACE
      @started = @started ? false : true
    when Gosu::KB_R
      reset
      @board.create_generation
    when Gosu::KB_ESCAPE
      close
    else
      super
    end
  end

  private

  def reset
    @started = false
    @board.reset
    @generation = 0
  end
end
