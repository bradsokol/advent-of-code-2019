#! /usr/bin/env ruby

WIDTH = 25
HEIGHT = 6
LAYER_SIZE = WIDTH * HEIGHT


data = $stdin.readline.strip.chars

zeros = data.each_slice(LAYER_SIZE).map { |layer| layer.count('0') }
i = zeros.index(zeros.min)

layer = data.slice(i * LAYER_SIZE, LAYER_SIZE)
puts layer.count('1') * layer.count('2')
puts ' '

image = []
HEIGHT.times { image << Array.new(WIDTH, '2') }

data.each_slice(LAYER_SIZE) do |layer|
  (0...HEIGHT).each do |row|
    (0...WIDTH).each do |column|
      pixel = layer.slice(row * WIDTH + column, 1)[0]
      if pixel != '2' && image[row][column] == '2'
        image[row][column] = pixel
      end
    end
  end
end

(0...HEIGHT).each do |row|
  (0...WIDTH).each do |column|
    print image[row][column] == '1' ? 'X' : ' '
  end
  $stdout.flush
  puts ''
end
