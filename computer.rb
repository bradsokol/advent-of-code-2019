#! /usr/bin/env ruby
# frozen_string_literal: true

class Computer
  def initialize(code)
    @halted = false
    @ip = 0
    @relative_base = 0

    @code = Hash.new(0)
    code.each_with_index { |value, i| @code[i] = value }
  end

  def compute(input_source = nil)
    @input_source = input_source
    while @code[@ip] != 99
      case @code[@ip] % 100
      when 1
        value1, value2, _store = parse3(@ip)
        write_value(@ip + 3, value1 + value2, @code[@ip] / 10000)
        @ip += 4
      when 2
        value1, value2, _store = parse3(@ip)
        write_value(@ip + 3, value1 * value2, @code[@ip] / 10000)
        @ip += 4
      when 3
        write_value(@ip + 1, @input_source.next_input, @code[@ip] / 100)
        @ip += 2
      when 4
        value = read_value(@ip + 1, @code[@ip] / 100)
        yield value
        @ip += 2
      when 5
        value1, value2 = parse2(@ip)
        @ip = value1 != 0 ? value2 : @ip + 3
      when 6
        value1, value2 = parse2(@ip)
        @ip = value1 == 0 ? value2 : @ip + 3
      when 7
        value1, value2, _store = parse3(@ip)
        write_value(@ip + 3, value1 < value2 ? 1 : 0, @code[@ip] / 10000)
        @ip += 4
      when 8
        value1, value2, _store = parse3(@ip)
        write_value(@ip + 3, value1 == value2 ? 1 : 0, @code[@ip] / 10000)
        @ip += 4
      when 9
        @relative_base += read_value(@ip + 1, @code[@ip] / 100)
        @ip += 2
      else
        puts "Bad opcode #{@code[@ip]} at #{@ip}"
        exit(1)
      end
    end
    @halted = true
  end

  def halted?
    @halted
  end

  private

  def read_value(location, parameter_mode)
    value = @code[location]
    case parameter_mode
    when 0
      @code[value]
    when 1
      value
    when 2
      @code[@relative_base + value]
    else
      puts "Bad parameter mode #{parameter_mode}"
      exit(1)
    end
  end

  def write_value(location, value, parameter_mode)
    final_location = @code[location]
    case parameter_mode
    when 0
      @code[final_location] = value
    when 2
      final_location += @relative_base
      if final_location < 0
        puts "Invalid address #{final_location}"
        exit(1)
      end
      @code[final_location] = value
    else
      puts "Unsupported parameter mode #{parameter_mode}"
      exit(1)
    end
  end

  def parse2(ip)
    op_code = @code[ip]

    parameter_mode = op_code % 1000 / 100
    value1 = read_value(ip + 1, parameter_mode)
    parameter_mode = op_code % 10000 / 1000
    value2 = read_value(ip + 2, parameter_mode)
    [value1, value2]
  end

  def parse3(ip)
    parse2(ip) << @code[ip + 3]
  end
end
