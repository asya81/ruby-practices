#!/usr/bin/env ruby
require 'date'
require 'optparse'
# 年月の先頭のスペースの数
HEADER_MARGIN_SPACES = 6
# 1日分の半角スペースの数
ONE_DAY_SPACES = 3
MONTH_LABEL = "月"
DAYS = "日 月 火 水 木 金 土"
CHARACTER_COLOR_BLACK = "\e[30m"
BACKGROUND_COLOR_WHITE = "\e[47m"
RESET_CODE = "\e[0m"

begin
  # コマンドラインから受け取った年月
  options = ARGV.getopts('y:', 'm:')
rescue OptionParser::InvalidOption
  puts "オプションには、 y（年）または m（月）のみ指定できます。"
  return
rescue OptionParser::MissingArgument
  puts "オプションの値を設定してください。"
  return
end
input_year, input_month = options["y"], options["m"]
error_message = []
error_message << "y オプションには、正の整数を指定してください。" if !input_year.nil? && input_year.to_i <= 0
error_message << "m オプションには、1〜12の整数を指定してください。" unless input_month.nil? || (1..12).cover?(input_month.to_i)
unless error_message.empty?
  puts error_message
  return
end

# 現在の年月
today = Date.today
current_year, current_month, current_day = today.year, today.month, today.day
# コマンドラインからの指定がない場合、現在の年月を表示
year = input_year.nil? ? current_year : input_year.to_i
month = input_month.nil? ? current_month : input_month.to_i
# 年月の先頭の余白
header_spaces = "\s" * HEADER_MARGIN_SPACES
# 第1週の先頭の余白
first_week_spaces = "\s" * ONE_DAY_SPACES * Date.new(year, month, 1).wday
# 表示月の最終日
last_day = Date.new(year, month, -1).day
# 表示する日付
dates = first_week_spaces
(1..last_day).each do |date|
  dates << "#{CHARACTER_COLOR_BLACK}#{BACKGROUND_COLOR_WHITE}" if date == current_day.to_i
  dates << sprintf("%2d", date)
  dates << RESET_CODE if date == current_day.to_i
  dates << "\s"
  dates << "\r\n" if Date.new(year, month, date).saturday?
end

# カレンダーを出力
puts(<<EOF)
#{header_spaces}#{month}#{MONTH_LABEL}\s#{year}         
#{DAYS}
#{dates}
EOF
