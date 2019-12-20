#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative './computer.rb'

code = File.open('day19.txt').readline.split(',').map(&:to_i)

class Analyzer
  def initialize(code)
    @code = code.dup
    @grid = []
    50.times { |_| @grid << ('?' * 50).split('') }
  end

  def analyze
    (0..49).each do |y|
      (0..49).each do |x|
        @input = [x, y]
        Computer.new(@code).compute(self) do |output|
          @grid[y][x] = output == 0 ? '.' : '#'
        end
      end
    end
    puts count
  end

  def count
    @grid.map { |line| line.count('#') }.sum
  end

  def next_input
    @input.shift
  end
end

Analyzer.new(code).analyze
