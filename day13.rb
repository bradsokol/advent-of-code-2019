#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative './computer.rb'

code = File.open('day13.txt').readline.split(',').map(&:to_i)

class Game
  attr_reader :grid, :score

  def initialize(code)
    @computer = Computer.new(code)
    @grid = {}
    @outputs = []
    @score = 0
    @paddle = nil
    @ball = nil
  end

  def play
    @computer.compute(self) do |output|
      if @outputs.length < 2
        @outputs << output
      else
        x = @outputs[0]
        y = @outputs[1]
        if x == -1 && y == 0
          @score = output
        else
          grid[@outputs] = output

          case output
          when 3
            @paddle = @outputs.dup
          when 4
            @ball = @outputs.dup
          end
        end
        @outputs.clear
      end
    end
  end

  def next_input
    if @paddle.empty?
      0
    else
      offset = @paddle[0] - @ball[0]
      if offset > 0
        -1
      else
        offset < 0 ? 1 : 0
      end
    end
  end
end

game = Game.new(code.dup)
game.play
puts game.grid.values.count(2)

hacked_code = code.dup
hacked_code[0] = 2
game = Game.new(hacked_code)
game.play

puts game.score
