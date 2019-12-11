#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def count_asteroids(grid, station_x, station_y)
  ranges = [
    [((station_x + 1)...grid[station_y].length), (0..station_y)],
    [(station_x...grid[station_y].length), ((station_y + 1)...grid.length)],
    [(0...station_x),(station_y...grid.length)],
    [(0..station_x), (0...station_y)],
  ]

  ranges.reduce(0) do |sum, ranges|
    vectors = Set.new
    ranges[0].each do |x|
      ranges[1].each do |y|
        next if x == station_x && y == station_y

        vectors.add((station_x - x.to_f) / (station_y - y.to_f)) if grid[y][x] == '#'
      end
    end
    sum + vectors.length
  end
end

grid = $stdin.readlines.map { |line| line.strip.chars }.compact

max = 0
grid.each_with_index do |row, y|
  row.each_with_index do |location, x|
    max = [count_asteroids(grid, x, y), max].max if location == '#'
  end
end

puts max
