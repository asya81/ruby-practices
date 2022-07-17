require 'date'
require 'optparse'

class Calendar
  # 年月の先頭のスペースの数
  HEADER_MARGIN_SPACES = 6
  # 1日分の半角スペースの数
  ONE_DAY_SPACES = 3
  MONTH_LABEL = "月"
  DAYS = "日 月 火 水 木 金 土"
  CHARACTER_COLOR_BLACK = "\e[30m"
  BACKGROUND_COLOR_WHITE = "\e[47m"
  RESET_CODE = "\e[0m"

  def generate
    year, month, errors = initialize_year_month
    return errors.join("\n") unless errors.empty?

    # 年月の先頭の余白
    header_spaces = "\s" * HEADER_MARGIN_SPACES
    # 第1週の先頭の余白
    first_week_spaces = "\s" * ONE_DAY_SPACES * Date.new(year, month, 1).wday
    # 表示月の最終日
    last_day = Date.new(year, month, -1).day
    # 表示する日付
    dates = ""
    (1..last_day).each do |day|
      current_date = Date.new(year, month, day)
      dates << "#{CHARACTER_COLOR_BLACK}#{BACKGROUND_COLOR_WHITE}" if current_date == today
      dates << sprintf("%2d", day)
      dates << RESET_CODE if current_date == today
      # 最終日は空白も改行も不要
      unless day == last_day
        if current_date.saturday?
          dates << "\n"
        else
          dates << "\s"
        end
      end
    end
    <<~EOF
    #{header_spaces}#{month}#{MONTH_LABEL}\s#{year}
    #{DAYS}
    #{first_week_spaces}#{dates}
    EOF
  end

  private

  def initialize_year_month
    errors = []
    begin
      # コマンドラインから受け取った年月
      options = ARGV.getopts('y:', 'm:')
    rescue OptionParser::InvalidOption
      errors << "オプションには、 y（年）または m（月）のみ指定できます。"
    rescue OptionParser::MissingArgument
      errors << "オプションの値を設定してください。"
    else
      year_text, month_text = options["y"], options["m"]
    end
    # コマンドラインからの指定がない場合、現在の年月を表示
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

  def today
    Date.today
  end
end
