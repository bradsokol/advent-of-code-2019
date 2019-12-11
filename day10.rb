#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def count_asteroids(station_x, station_y)
  vectors = Set.new
  ((station_x + 1)...$grid[station_y].length).each do |x|
    (0..station_y).each do |y|
      next if x == station_x && y == station_y
      vectors.add((station_x - x.to_f) / (station_y - y.to_f)) if $grid[y][x] == '#'
    end
  end
  sum = vectors.length

  vectors = Set.new
  (station_x...$grid[station_y].length).each do |x|
    ((station_y + 1)...$grid.length).each do |y|
      next if x == station_x && y == station_y
      vectors.add((station_x - x.to_f) / (station_y - y.to_f)) if $grid[y][x] == '#'
    end
  end
  sum += vectors.length

  vectors = Set.new
  (0...station_x).each do |x|
    (station_y...$grid.length).each do |y|
      next if x == station_x && y == station_y
      vectors.add((station_x - x.to_f) / (station_y - y.to_f)) if $grid[y][x] == '#'
    end
  end
  sum += vectors.length

  vectors = Set.new
  (0..station_x).each do |x|
    (0...station_y).each do |y|
      next if x == station_x && y == station_y
      vectors.add((station_x - x.to_f) / (station_y - y.to_f)) if $grid[y][x] == '#'
    end
  end
  sum += vectors.length

  sum
end

$grid = $stdin.readlines.map { |line| line.strip.chars }.compact

max = 0
$grid.each_with_index do |row, y|
  row.each_with_index do |location, x|
    if location == '#'
      max = [count_asteroids(x, y), max].max
    end
  end
end

puts max
