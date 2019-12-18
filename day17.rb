#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative './computer.rb'

code = File.open('day17.txt').readline.split(',').map(&:to_i)

map = [[]]
y = 0
Computer.new(code.dup).compute(nil) do |output|
  ascii = output.to_i
  if ascii == 10
    y += 1
    map << []
  else
    map[y] << ascii.chr
  end
end

intersections = []
min_y = 1
max_y = map.length - 2
min_x = 1
max_x = map[0].length - 2

def intersection?(map, x, y)
  map[y][x] == '#' &&
    map[y - 1][x] == '#' &&
    map[y + 1][x] == '#' &&
    map[y][x - 1] == '#' &&
    map[y][x + 1] == '#'
end

(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    intersections << [x, y] if intersection?(map, x, y)
  end
end

puts intersections.sum { |intersection| intersection[0] * intersection[1] }
