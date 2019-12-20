#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative './computer.rb'

code = File.open('day19.txt').readline.split(',').map(&:to_i)

class Analyzer
  def initialize(code)
    @code = code.dup
    @grid = [['#']]
  end

  def analyze
    add_to_grid until test
  end

  def add_to_grid
    @grid.each_with_index do |row, y|
      compute((row.length..row.length), y)
    end
    compute((0...@grid[0].length), @grid.length)
  end

  def next_input
    @input.shift
  end

  private

  def print_grid
    (0..@grid.length).each do |y|
      (0..@grid[y].length).each do |x|
        print @grid[y][x]
      end
      print "\n"
      $stdout.flush
    end
  end

  def test
    return false if @grid.length < 100

    x1 = @grid[-1].index('#')
    x2 = @grid[-100].rindex('#')
    return false if x1.nil? || x2.nil?
    if (x2 - x1) >= 99
      puts x1 * 10000 + @grid.length - 99
      return true
    end
    false
  end

  def compute(x_range, y)
    x_range.each do |x|
      @grid << [] if x == 0
      @input = [x, y]
      Computer.new(@code).compute(self) do |output|
        @grid[y][x] = output == 0 ? '.' : '#'
      end
    end
  end

  def count
    @grid.map { |line| line.count('#') }.sum
  end
end

Analyzer.new(code).analyze
