#! /usr/bin/env ruby

# frozen_string_literal: true

require 'set'

def parse_segment(segment)
  [segment[0], segment[1..-1].to_i]
end

def calculate(direction, distance, x, y)
  case direction
  when 'U'
    y += distance
  when 'R'
    x += distance
  when 'D'
    y -= distance
  when 'L'
    x -= distance
  end
  [x, y]
end

def find_intersection(pair, segments)
  x1 = pair[0][0]
  y1 = pair[0][1]
  x2 = pair[1][0]
  y2 = pair[1][1]

  intersections = []
  segments.each do |segment|
    xx1 = segment[0][0]
    yy1 = segment[0][1]
    xx2 = segment[1][0]
    yy2 = segment[1][1]

    if x1 == x2
      # x1/y1 is vertical
      if x1 >= [xx1, xx2].min && x1 <= [xx1, xx2].max &&
          [y1, y2].min <= yy1 && [y1, y2].max >= yy1
        intersections << [x1, yy1]
      end
    else
      # xx1/yy1 is vertical
      if xx1 >= [x1, x2].min && xx1 <= [x1, x2].max &&
          [yy1, yy2].min <= y1 && [yy1, yy2].max >= y1
        intersections << [xx1, y1]
      end
    end
  end

  unless intersections.empty?
    intersections.min { |a, b| a.inject(0) { |sum, n| sum + n.abs } <=> b.inject(0) { |sum, n| sum + n .abs} }
  else
    nil
  end
end

wire1 = $stdin.readline.split(',')
wire2 = $stdin.readline.split(',')

x = 0
y = 0
segments = Set.new
wire1.each do |segment|
  direction, distance = parse_segment(segment)
  pair = [[x, y], calculate(direction, distance, x, y)]
  segments.add(pair)
  x = pair[1][0]
  y = pair[1][1]
end

x = 0
y = 0
minimum_distance = 999_999_999
wire2.each do |segment|
  direction, distance = parse_segment(segment)
  pair = [[x, y], calculate(direction, distance, x, y)]
  intersection = find_intersection(pair, segments)
  unless intersection.nil?
    d = intersection.inject(0) { |sum, n| sum + n.abs }
    minimum_distance = d if d < minimum_distance && d > 0
  end

  x = pair[1][0]
  y = pair[1][1]
end

puts minimum_distance
