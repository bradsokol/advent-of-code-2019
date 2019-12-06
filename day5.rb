#! /usr/bin/env ruby

# frozen_string_literal: true

$code = $stdin.readline.split(',').map(&:to_i)
backup = $code.dup

def parse_value(location, parameter_mode)
  value = $code[location]
  parameter_mode == 0 ? $code[value] : value
end

def parse2(ip)
  op_code = $code[ip]

  parameter_mode = op_code % 1000 / 100
  value1 = parse_value(ip + 1, parameter_mode)
  parameter_mode = op_code % 10000 / 1000
  value2 = parse_value(ip + 2, parameter_mode)
  [value1, value2]
end

def parse3(ip)
  parse2(ip) << $code[ip + 3]
end

def compute(input)
  ip = 0
  while $code[ip] != 99
    case $code[ip] % 100
    when 1
      value1, value2, store = parse3(ip)
      $code[store] = value1 + value2
      ip += 4
    when 2
      value1, value2, store = parse3(ip)
      $code[store] = value1 * value2
      ip += 4
    when 3
      $code[$code[ip + 1]] = input
      ip += 2
    when 4
      value = parse_value(ip + 1, $code[ip] / 100)
      puts "Output: #{value}"
      ip += 2
    when 5
      value1, value2 = parse2(ip)
      ip = (value1 != 0) ? value2 : (ip + 3)
    when 6
      value1, value2 = parse2(ip)
      ip = (value1 == 0) ? value2 : (ip + 3)
    when 7
      value1, value2, store = parse3(ip)
      $code[store] = (value1 < value2) ? 1 : 0
      ip += 4
    when 8
      value1, value2, store = parse3(ip)
      $code[store] = (value1 == value2) ? 1 : 0
      ip += 4
    else
      puts "Bad opcode #{$code[ip]} at #{ip}"
      exit(1)
    end
  end
end

compute(1)
puts ' '
$code = backup.dup
compute(5)
