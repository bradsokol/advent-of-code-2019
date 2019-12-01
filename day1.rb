#! /usr/bin/env ruby

# frozen_string_literal: true

modules = File.open('day1.txt').readlines.map(&:to_i)

puts modules.inject(0) { |memo, m| memo + ((m / 3) - 2) }

def calculate_fuel(m)
  fuel = (m / 3) - 2
  if fuel > 0
    fuel + calculate_fuel(fuel)
  else
    0
  end
end

puts modules.inject(0) { |memo, m| memo += calculate_fuel(m) }
