#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative './computer.rb'

code = File.open('day15.txt').readline.split(',').map(&:to_i)

class Step
  attr_reader :direction

  def initialize(x, y)
    @x = x
    @y = y
    @direction = 1
  end

  def location
    [@x, @y]
  end

  def next_direction
    @direction = if @direction == 0
      @direction
    else
      (@direction + 1) % 5
    end
  end
end

class Robot
  def initialize(code)
    @computer = Computer.new(code.dup)
    @path = [Step.new(0, 0)]
    @map = Hash.new('?')
    @map[@path.last.location] = '.'
  end

  def explore
    @computer.compute(self) do |output|
      location  = @path.last.location
      puts "Output: #{output} at #{location}"
      @map[location] = case output
      when 0
        @path.pop
        '#'
      when 1
        '.'
      when 2
        puts "Steps to oxygen: #{@path.length}"
        exit(0)
        'O'
      end
    end
  end

  def next_input
    next_step
    puts "Input: #{@path.last.direction} at #{@path.last.location}"
    @path.last.direction
  end

  def print_map
    min_x = @map.keys.map { |key| key[0] }.min
    max_x = @map.keys.map { |key| key[0] }.max
    min_y = @map.keys.map { |key| key[1] }.min
    max_y = @map.keys.map { |key| key[1] }.max

    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        print @map[[x, y]]
      end
      puts "\n"
    end
  end

  private

  def next_step
    while true
      print_map if @path.last.nil?
      next_direction = @path.last.direction
      # puts "#{next_direction} #{@x} #{@y} #{@path.length}"
      if next_direction == 0
        @path.pop
      else
        x, y = @path.last.location
        new_location = case next_direction
        when 1
          [x, y + 1]
        when 2
          [x, y - 1]
        when 3
          [x - 1, y]
        when 4
          [x + 1, y]
        end
        @path.last.next_direction
        next if @map.key?(new_location)
        @path.push(Step.new(new_location[0], new_location[1]))
        break
      end
    end
  end
end

Robot.new(code).explore
