#! /usr/bin/env ruby

# frozen_string_literal: true

code = $stdin.readline.split(',').map(&:to_i)
code[1] = 12
code[2] = 2

ip = 0
while code[ip] != 99
  location1 = code[ip + 1]
  location2 = code[ip + 2]
  store = code[ip + 3]

  if code[ip] == 1
    code[store] = code[location1] + code[location2]
  elsif code[ip] == 2
    code[store] = code[location1] * code[location2]
  else
    puts "Bad opcode #{code[ip]} at #{ip}"
    exit(1)
  end

  ip += 4
end

puts code[0]
