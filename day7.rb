#! /usr/bin/env ruby

# frozen_string_literal: true

$code = $stdin.readline.split(',').map(&:to_i)
$backup = $code.dup

def parse_value(code, location, parameter_mode)
  value = code[location]
  parameter_mode == 0 ? code[value] : value
end

def parse2(code, ip)
  op_code = code[ip]

  parameter_mode = op_code % 1000 / 100
  value1 = parse_value(code, ip + 1, parameter_mode)
  parameter_mode = op_code % 10000 / 1000
  value2 = parse_value(code, ip + 2, parameter_mode)
  [value1, value2]
end

def parse3(code, ip)
  parse2(code, ip) << code[ip + 3]
end

def compute(code, ip, input, phase)
  inputs = [input, phase]
  while code[ip] != 99
    # puts "ip: #{ip} op code: #{code[ip]}"
    case code[ip] % 100
    when 1
      value1, value2, store = parse3(code, ip)
      code[store] = value1 + value2
      ip += 4
    when 2
      value1, value2, store = parse3(code, ip)
      code[store] = value1 * value2
      ip += 4
    when 3
      code[code[ip + 1]] = inputs.pop
      ip += 2
    when 4
      value = parse_value(code, ip + 1, code[ip] / 100)
      return value, ip
    when 5
      value1, value2 = parse2(code, ip)
      if ip ==6 && code[ip] == 105
        # puts "#{value1} #{value2}"
      end
      ip = (value1 != 0) ? value2 : (ip + 3)
    when 6
      value1, value2 = parse2(code, ip)
      ip = (value1 == 0) ? value2 : (ip + 3)
    when 7
      value1, value2, store = parse3(code, ip)
      code[store] = (value1 < value2) ? 1 : 0
      ip += 4
    when 8
      value1, value2, store = parse3(code, ip)
      code[store] = (value1 == value2) ? 1 : 0
      ip += 4
    else
      puts "Bad opcode #{code[ip]} at #{ip}"
      exit(1)
    end
  end
  puts 'Halt!'
  return nil, nil
end

def amplify(phase_settings)
  phase_settings.reduce(0) { |signal, phase| compute($backup.dup, 0, signal, phase).first }
end

def amplify_with_feedback(phase_settings)
  signal = 0
  e = 0
  code = [[$backup.dup, 0], [$backup.dup, 0], [$backup.dup, 0], [$backup.dup, 0], [$backup.dup, 0]] 

  phase_settings.each_with_index do |phase, i|
    signal, ip = compute(code[i][0], code[i][1], signal, phase)
    return e if signal.nil?
    code[i][1] = ip
  end
  e = signal

  while true
    (0..4).each do |i|
      signal, ip = compute(code[i][0], code[i][1], nil, signal)
      return e if signal.nil?
      code[i][1] = ip
    end
    e = signal
  end
end

m = [0, 1, 2, 3, 4].permutation.map do |p|
  amplify(p)
end.max
puts m
puts ' '

m = [5, 6, 7, 8, 9].permutation.map do |p|
  amplify_with_feedback(p)
end
puts m
