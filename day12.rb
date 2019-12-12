#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

class Moon
  attr_accessor :x, :y, :z, :vx, :vy, :vz

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
    @vx = @vy = @vz = 0
  end

  def apply_velocity
    @x += vx
    @y += vy
    @z += vz
  end

  def energy
    (x.abs + y.abs + z.abs) * (vx.abs + vy.abs + vz.abs)
  end

  def to_s
    "(#{x}, #{y}, #{z}) (#{vx}, #{vy}, #{vz})"
  end
end

def apply_gravity(moons)
  moons.combination(2) do |pair|
    slower, faster = pair.sort { |a, b| a.x <=> b.x }
    if slower.x != faster.x
      slower.vx += 1
      faster.vx -= 1
    end

    slower, faster = pair.sort { |a, b| a.y <=> b.y }
    if slower.y != faster.y
      slower.vy += 1
      faster.vy -= 1
    end

    slower, faster = pair.sort { |a, b| a.z <=> b.z }
    if slower.z != faster.z
      slower.vz += 1
      faster.vz -= 1
    end
  end
end

moons = File.open('day12.txt').readlines.map do |line|
  x, y, z = line.scan(/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/).first.map(&:to_i)
  Moon.new(x, y, z)
end

1_000.times do
  apply_gravity(moons)
  moons.each(&:apply_velocity)
end

puts moons.reduce(0) { |sum, moon| sum + moon.energy }
