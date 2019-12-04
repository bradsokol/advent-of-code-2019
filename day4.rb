#! /usr/bin/env ruby

# frozen_string_literal: true

def valid_password?(password)
  s = password.to_s
  repeat = false
  5.times do |i|
    return false if s[i] > s[i + 1]
    repeat = true if s[i] == s[i + 1] && !repeat
  end
  repeat
end

def valid_password2?(password)
  s = password.to_s
  repeat = false
  5.times do |i|
    return false if s[i] > s[i + 1]
    if !repeat
      if s[i] == s[i + 1]
        if i < 4
          if s[i + 2] != s[i]
            repeat = true
          end
        else
          repeat = true
        end
        if i > 0
          repeat = false if s[i - 1] == s[i]
        end
      end
    end
  end
  repeat
end

count = 0
(273025..767253).each do |password|
  count += 1 if valid_password?(password)
end
puts count

count = 0
(273025..767253).each do |password|
  count += 1 if valid_password2?(password)
end
puts count
