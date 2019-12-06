#! /usr/bin/env ruby

# frozen_string_literal: true

class Body
  attr_accessor :satellites
  attr_reader :name

  def initialize(name)
    @name = name
    @satellites = []
  end

  def to_s
    puts "name: #{name} satellites: #{satellites.length}"
  end
end

def count(body, depth)
  depth += 1
  (depth * body.satellites.length) + body.satellites.map { |satellite| count(satellite, depth) }.sum
end

def path_to_com(body)
  path = []
  while body.name != 'COM'
    body = $bodies[$parents[body.name]]
    path << body.name
  end
  path
end

$bodies = {}
$parents = {}
com = nil
me = nil
santa = nil

File.open('day6.txt').readlines.each do |line|
  a, b = line.strip.scan(/([A-Z0-9]+)\)([A-Z0-9]+)/).first

  body = $bodies[a] || Body.new(a)
  satellite = $bodies[b] || Body.new(b)
  body.satellites << satellite

  com = body if body.name == 'COM'
  me = satellite if satellite.name == 'YOU'
  santa = satellite if satellite.name == 'SAN'

  $bodies[body.name] = body
  $bodies[satellite.name] = satellite
  $parents[satellite.name] = body.name
end

puts count(com, 0)
puts ' '

me_path = path_to_com(me)
santa_path = path_to_com(santa)

me_path.each_with_index do |body, i|
  j = santa_path.index(body)
  if j
    puts i + j
    exit(0)
  end
end
