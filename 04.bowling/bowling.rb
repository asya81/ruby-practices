#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each { |s| shots << (s == 'X' ? 10 : s.to_i) }

point = 0
frame = 0
next_frame = 0
# 10フレーム目が2投の場合を考慮してshotsに0を追加
(shots << 0).each_cons(3) do |three_shots|
  if next_frame > 1
    next_frame -= 1
    next
  else
    frame += 1
  end
  first_shot, second_shot = three_shots.take(2)
  if frame == 10
    point += three_shots.sum
    break
  elsif first_shot == 10
    point += three_shots.sum
    next_frame = 1
  elsif first_shot + second_shot == 10
    point += three_shots.sum
    next_frame = 2
  else
    point += first_shot + second_shot
    next_frame = 2
  end
end

p point
