#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'set'

def count_asteroids(grid, station_x, station_y)
  ranges = build_ranges(grid, station_x, station_y)

  ranges.reduce(0) do |sum, quadrant_ranges|
    vectors = Set.new
    quadrant_ranges[0].each do |x|
      quadrant_ranges[1].each do |y|
        next if x == station_x && y == station_y

        vectors.add((station_x - x.to_f) / (station_y - y.to_f)) if grid[y][x] == '#'
      end
    end
    sum + vectors.length
  end
end

def build_ranges(grid, x, y)
  [
    [((x + 1)...grid[y].length), (0..y)],
    [(x...grid[y].length), ((y + 1)...grid.length)],
    [(0...x), (y...grid.length)],
    [(0..x), (0...y)],
  ]
end

def build_targetting(grid, station_x, station_y)
  ranges = build_ranges(grid, station_x, station_y)

  quadrants = []
  ranges.each do |x_range, y_range|
    quadrant = Hash.new { |h, k| h[k] = [] }
    x_range.each do |x|
      y_range.each do |y|
        next if x == station_x && y == station_y

        location = grid[y][x]
        next unless location == '#'

        dx = x.to_f - station_x 
        dy = y.to_f - station_y
        trajectory = dy / dx
        distance = Math.sqrt(dx.abs * dx.abs + dy.abs * dy.abs)
        quadrant[trajectory] << [distance, [x, y]]
      end
    end
    quadrant.values.each { |v| v.sort! { |a, b| a.first <=> b.first } }
    quadrants << quadrant
  end
  quadrants
end

def done(point)
  puts point[0] * 100 + point[1]
  exit(0)
end

# grid = File.open('day10-1.txt').readlines.map { |line| line.strip.chars }.compact
grid = $stdin.readlines.map { |line| line.strip.chars }.compact

max = 0
max_location = nil
grid.each_with_index do |row, y|
  row.each_with_index do |location, x|
    next unless location == '#'

    count = count_asteroids(grid, x, y)
    if count > max
      max = count
      max_location = [x, y]
    end
  end
end

puts "#{max} at (#{max_location[0]}, #{max_location[1]})"

q1, q2, q3, q4 = build_targetting(grid, max_location[0], max_location[1])

iterations = 0
while true do
  q1.keys.sort.each do |trajectory|
    next_target = q1[trajectory].shift
    iterations += 1
    done(next_target.last) if iterations == 200
  end
  q2.keys.sort.each do |trajectory|
    next_target = q2[trajectory].shift
    iterations += 1
    done(next_target.last) if iterations == 200
  end
  q3.keys.sort.reverse.each do |trajectory|
    next_target = q3[trajectory].shift
    iterations += 1
    done(next_target.last) if iterations == 200
  end
  q4.keys.sort.each do |trajectory|
    next_target = q4[trajectory].shift
    iterations += 1
    done(next_target.last) if iterations == 200
  end
end
