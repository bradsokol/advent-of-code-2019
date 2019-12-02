#! /usr/bin/env ruby

# frozen_string_literal: true

memory = $stdin.readline.split(',').map(&:to_i)

0.upto(99) do |noun|
  0.upto(99) do |verb|
    code = memory.dup
    code[1] = noun
    code[2] = verb
    ip = 0

    while code[ip] != 99
      opcode, location1, location2, store = code.slice(ip, 4)

      if opcode == 1
        code[store] = code[location1] + code[location2]
      elsif code[ip] == 2
        code[store] = code[location1] * code[location2]
      else
        puts "Bad opcode #{code[ip]} at #{ip}"
        exit(1)
      end

      ip += 4
    end

    if code[0] == 19690720
      puts noun * 100 + verb
      exit(0)
    end
  end
end
