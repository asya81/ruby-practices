require 'date'
require 'optparse'

class Calendar
  CHARACTER_COLOR_BLACK = "\e[30m"
  BACKGROUND_COLOR_WHITE = "\e[47m"
  RESET_CODE = "\e[0m"

  def generate
    today = Date.today
    year, month, errors = initialize_year_month(today)
    return errors.join("\n") unless errors.empty?

    dates = []
    first_date = Date.new(year, month, 1)
    last_date = Date.new(year, month, -1)
    (first_date..last_date).each do |current_date|
      dates << "#{CHARACTER_COLOR_BLACK}#{BACKGROUND_COLOR_WHITE}" if current_date == today
      dates << sprintf("%2d", current_date.day)
      dates << RESET_CODE if current_date == today

      unless current_date == last_date
        if current_date.saturday?
          dates << "\n"
        else
          dates << "\s"
        end
      end
    end

    <<~EOF
    #{"\s" * 6}#{month}月\s#{year}
    日 月 火 水 木 金 土
    #{"\s" * 3 * first_date.wday}#{dates.join}
    EOF
  end

  private

  def initialize_year_month(today)
    errors = []
    begin
      options = ARGV.getopts('y:', 'm:')
    rescue OptionParser::InvalidOption
      errors << "オプションには、 y（年）または m（月）のみ指定できます。"
    rescue OptionParser::MissingArgument
      errors << "オプションの値を設定してください。"
    else
      year_text, month_text = options["y"], options["m"]
    end

    if year_text.nil?
      year = today.year
    elsif year_text.to_i.between?(1, 9999)
      year = year_text.to_i
    else
      errors << "y オプションには、1〜9999の整数を指定してください。"
    end

    if month_text.nil?
      month = today.month
    elsif month_text.to_i.between?(1, 12)
      month = month_text.to_i
    else
      errors << "m オプションには、1〜12の整数を指定してください。"
    end

    return year, month, errors
  end
end
