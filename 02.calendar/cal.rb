#!/usr/bin/env ruby
require 'date'
require 'optparse'
# コマンドラインから受け取った年月
options = ARGV.getopts('y:', 'm:')
input_year, input_month = options["y"], options["m"]
# 現在の年月
today = Date.today
current_year, current_month = today.year, today.month
# コマンドラインからの指定がない場合、現在の年月を表示
year = input_year.nil? ? current_year : input_year.to_i
month = input_month.nil? ? current_month : input_month.to_i
# 表示月の最終日
last_day = Date.new(year, month, -1).day
# 表示する日付
dates = ""
(1..last_day).each do |date|
  dates << "#{sprintf("%2d ", date)}"
  dates << "\r\n" if Date.new(year, month, date).saturday?
end
puts(<<EOF)
      #{month}月 #{year}         
日 月 火 水 木 金 土  
          #{dates}
EOF

# 出力結果のイメージ（yに2022、mに6を指定した場合）
#       6月 2022
# 日 月 火 水 木 金 土
#           1  2  3  4
#  5  6  7  8  9 10 11
# 12 13 14 15 16 17 18
# 19 20 21 22 23 24 25
# 26 27 28 29 30
