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

def find_intersections(pair, segments)
  x1 = pair[0][0]
  y1 = pair[0][1]
  x2 = pair[1][0]
  y2 = pair[1][1]

  intersections = []
  segments.each_with_index do |segment, i|
    xx1 = segment[0][0][0]
    yy1 = segment[0][0][1]
    xx2 = segment[0][1][0]
    yy2 = segment[0][1][1]

    if x1 == x2
      # x1/y1 is vertical
      if x1 >= [xx1, xx2].min && x1 <= [xx1, xx2].max &&
          [y1, y2].min <= yy1 && [y1, y2].max >= yy1
        intersections << [[x1, yy1], i]
      end
    else
      # xx1/yy1 is vertical
      if xx1 >= [x1, x2].min && xx1 <= [x1, x2].max &&
          [yy1, yy2].min <= y1 && [yy1, yy2].max >= y1
        intersections << [[xx1, y1], i]
      end
    end
  end
  intersections
end

def wire_distance(cumulative_distance, pair, location)
  if pair[0][0] == pair[1][0]
    # Vertical
    cumulative_distance + (pair[0][1] - location[1]).abs
  else
    cumulative_distance + (pair[0][0] - location[0]).abs
  end
end

wire1 = $stdin.readline.split(',')
wire2 = $stdin.readline.split(',')

x = 0
y = 0
cumulative_distance = 0
segments = []
wire1.each do |segment|
  direction, distance = parse_segment(segment)
  pair = [[x, y], calculate(direction, distance, x, y)]
  segments << [pair, cumulative_distance]
  x = pair[1][0]
  y = pair[1][1]
  cumulative_distance += distance
end

x = 0
y = 0
cumulative_distance = 0
minimum = 999_999_999
wire2.each do |segment|
  direction, distance = parse_segment(segment)
  pair = [[x, y], calculate(direction, distance, x, y)]
  intersections = find_intersections(pair, segments)

  unless intersections.empty?
    intersections.each do |location, i|
      sum = wire_distance(segments[i][1], segments[i][0], location) +
        wire_distance(cumulative_distance, pair, location)
      minimum = sum if sum < minimum && sum > 0
    end
  end

  x = pair[1][0]
  y = pair[1][1]
  cumulative_distance += distance
end

puts minimum
