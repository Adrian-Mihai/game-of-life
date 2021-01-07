# frozen_string_literal: true

require 'matrix'

require_relative 'square'

class Board
  BOARD_OFFSET_WIGHT = ENV.fetch('BOARD_OFFSET_WIDTH').to_i
  BOARD_OFFSET_HEIGHT = ENV.fetch('BOARD_OFFSET_HEIGHT').to_i

  SQUARE_SIZE = ENV.fetch('SQUARE_SIZE').to_i
  POPULATION_FACTOR = ENV.fetch('POPULATION_FACTOR').to_f

  def initialize(game_width, game_height)
    @rows = (game_height - 2 * BOARD_OFFSET_HEIGHT) / SQUARE_SIZE
    @cols = (game_width - 2 * BOARD_OFFSET_WIGHT) / SQUARE_SIZE
    @aux = Matrix.build(@rows, @cols) { 0 }
    @squares = squares
    create_generation
  end

  def draw
    @squares.each do |square|
      color = square.state.positive? ? Gosu::Color::YELLOW : Gosu::Color::GRAY
      Gosu.draw_rect(square.x, square.y, SQUARE_SIZE - 1, SQUARE_SIZE - 1, color)
    end
  end

  def update
    @squares.each_with_index do |square, row, col|
      neighbors = count_neighbors(row, col)
      @aux[row, col] = generate_state(square, neighbors)
    end

    @squares.each_with_index { |_, row, col| @squares[row, col].state = @aux[row, col] }
  end

  def generate_state(square, neighbors)
    return 0 if square.state.positive? && ([0, 1].include?(neighbors) || neighbors >= 4)
    return 1 if square.state.zero? && neighbors == 3

    square.state
  end

  def create_generation
    @squares.each { |square| square.state = rand <= POPULATION_FACTOR ? 1 : 0 }
  end

  def reset
    @squares.each { |square| square.state = 0 }
  end

  private

  def squares
    Matrix.build(@rows, @cols) do |row, col|
      Square.new(col * SQUARE_SIZE + BOARD_OFFSET_WIGHT, row * SQUARE_SIZE + BOARD_OFFSET_HEIGHT)
    end
  end

  def count_neighbors(row, col)
    neighbors = if row.zero? && col.zero?
                  [@squares[row + 1, col], @squares[row, col + 1], @squares[row + 1, col + 1]]
                elsif row.zero?
                  [
                    @squares[row + 1, col], @squares[row, col + 1], @squares[row, col - 1],
                    @squares[row + 1, col + 1], @squares[row + 1, col - 1]
                  ]
                elsif col.zero?
                  [
                    @squares[row + 1, col], @squares[row - 1, col], @squares[row, col + 1],
                    @squares[row + 1, col + 1], @squares[row - 1, col + 1]
                  ]
                else
                  [
                    @squares[row + 1, col], @squares[row - 1, col], @squares[row, col + 1], @squares[row, col - 1],
                    @squares[row + 1, col + 1], @squares[row - 1, col + 1], @squares[row + 1, col - 1],
                    @squares[row - 1, col - 1]
                  ]
                end
    neighbors = neighbors.compact.map { |neighbor| neighbor if neighbor.state.positive? }
    neighbors.compact.count
  end
end
