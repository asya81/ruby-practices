#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []

# TODO: shotsにはストライクの場合も0を追加せず、Xを10にそれ以外は数値に変換するのみとする。
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# TODO: スコアの計算方法を旧ルールのものに変更する
# 1投目から順に、スコアの計算をしていく。
# 今回の点数が10だった場合、ストライク：今回を含めた3投分を合計してスコアとし、次のショットに進む。
# 今回の点数が10以外かつ次の点数との合計が10の場合、スペア：今回を含めた3投分を合計してスコアとし、2つ後のショットに進む。
# 今回の点数と次の点数との合計が10ではない場合、オープンフレーム： 今回を含めた2投分を合計してスコアとし、2つ後のショットに進む。
frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each do |frame|
  if frame[0] == 10 # strike
    point += 30
  elsif frame.sum == 10 # spare
    point += frame[0] + 10
  else
    point += frame.sum
  end
end

puts point
