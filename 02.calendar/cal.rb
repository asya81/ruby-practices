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

def initialize_options(error: "")
  begin
    # コマンドラインから受け取った年月
    options = ARGV.getopts('y:', 'm:')
  rescue OptionParser::InvalidOption
    error << "オプションには、 y（年）または m（月）のみ指定できます。"
  rescue OptionParser::MissingArgument
    error << "オプションの値を設定してください。"
  ensure
    return options, error
  end
end

def initialize_parameters(input_year:, input_month:, errors: [])
  # 現在の年月
  today = Date.today
  current_year, current_month = today.year, today.month
  # コマンドラインからの指定がない場合、現在の年月を表示
  if input_year.nil?
    display_year = current_year
  elsif input_year.to_i <= 0
    errors << "y オプションには、1〜9999の整数を指定してください。"
  else
    display_year = input_year.to_i
  end
  if input_month.nil?
    display_month = current_month
  elsif !(1..12).cover?(input_month.to_i)
    errors << "m オプションには、1〜12の整数を指定してください。"
  else
    display_month = input_month.to_i
  end
  return display_year, display_month, today.day.to_i, errors
end

def generate_calendar(year:, month:, day:)
  # 年月の先頭の余白
  header_spaces = "\s" * HEADER_MARGIN_SPACES
  # 第1週の先頭の余白
  first_week_spaces = "\s" * ONE_DAY_SPACES * Date.new(year, month, 1).wday
  # 表示月の最終日
  last_day = Date.new(year, month, -1).day
  # 表示する日付
  dates = first_week_spaces
  (1..last_day).each do |date|
    dates << "#{CHARACTER_COLOR_BLACK}#{BACKGROUND_COLOR_WHITE}" if date == day
    dates << sprintf("%2d", date)
    dates << RESET_CODE if date == day
    dates << "\s"
    dates << "\r\n" if Date.new(year, month, date).saturday?
  end
  <<-EOF
  #{header_spaces}#{month}#{MONTH_LABEL}\s#{year}         
  #{DAYS}
  #{dates}
  EOF
end

options, options_error = initialize_options
if options_error.empty?
  year, month, day, params_errors = initialize_parameters(input_year: options["y"], input_month: options["m"])
else
  puts options_error
  return
end
if params_errors.empty?
  puts generate_calendar(year: year, month: month, day: day)
else
  puts params_errors
  return
end
