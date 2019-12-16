#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

class Chemical
  attr_reader :amount, :name

  def initialize(text)
    @amount, @name = text.scan(/(\d+) ([A-Z]+)/).first
    @amount = @amount.to_i
  end

  def to_s
    "#{amount} #{name}"
  end
end

class Reaction
  attr_reader :inputs, :output

  def initialize(inputs, output)
    @output = Chemical.new(output)
    @inputs = inputs.split(', ').map { |input| Chemical.new(input) }
  end
end

class Reactor
  def initialize(reactions)
    @reactions = reactions
    @products = Hash.new(0)
  end

  def perform(needed)
    ore = 0
    needed.times do
      ore += react(@reactions['FUEL'], 0)
    end
    ore
  end

  private

  def react(reaction, ores)
    reaction.inputs.each do |input|
      if input.name == 'ORE'
        ores += input.amount
      else
        while (input.amount - @products[input.name]) > 0
          ores = react(@reactions[input.name], ores)
        end
        @products[input.name] -= input.amount
      end
    end
    @products[reaction.output.name] += reaction.output.amount
    ores
  end
end

reactions = {}
# $stdin.readlines.each do |line|
File.open('day14.txt').readlines.each do |line|
  inputs, outputs = line.scan(/(.*) => (.*)/).first
  reaction = Reaction.new(inputs, outputs)
  reactions[reaction.output.name] = reaction
end
puts Reactor.new(reactions).perform(1)

puts Reactor.new(reactions).perform(100000)
# ores = 0
# fuel = 0
# reactor = Reactor.new(reactions)
# until ores >= 1_000_000_000_000
#   ores += reactor.perform
#   fuel += 1
# end
