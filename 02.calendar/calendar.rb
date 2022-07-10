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

  def initialize
    @today = Date.today
    @current_year, @current_month = @today.year, @today.month
  end

  def initialize_options
    error = ""
    begin
      # コマンドラインから受け取った年月
      options = ARGV.getopts('y:', 'm:')
      @input_year, @input_month = options["y"], options["m"]
    rescue OptionParser::InvalidOption
      error << "オプションには、 y（年）または m（月）のみ指定できます。"
    rescue OptionParser::MissingArgument
      error << "オプションの値を設定してください。"
    end

    error
  end

  def initialize_parameters
    errors = []
    # コマンドラインからの指定がない場合、現在の年月を表示
    if @input_year.nil?
      @display_year = @current_year
    elsif @input_year.to_i.between?(1, 9999)
      @display_year = @input_year.to_i
    else
      errors << "y オプションには、1〜9999の整数を指定してください。"
    end
    if @input_month.nil?
      @display_month = @current_month
    elsif @input_month.to_i.between?(1, 12)
      @display_month = @input_month.to_i
    else
      errors << "m オプションには、1〜12の整数を指定してください。"
    end

    errors
  end

  def generate
    # 年月の先頭の余白
    header_spaces = "\s" * HEADER_MARGIN_SPACES
    # 第1週の先頭の余白
    first_week_spaces = "\s" * ONE_DAY_SPACES * Date.new(@display_year, @display_month, 1).wday
    # 表示月の最終日
    last_day = Date.new(@display_year, @display_month, -1).day
    # 表示する日付
    dates = ""
    (1..last_day).each do |date|
      current_date = Date.new(@display_year, @display_month, date)
      dates << "#{CHARACTER_COLOR_BLACK}#{BACKGROUND_COLOR_WHITE}" if current_date == @today
      dates << sprintf("%2d", date)
      dates << RESET_CODE if current_date == @today
      dates << "\s"
      dates << "\n" if current_date.saturday?
    end
    <<~EOF
    #{header_spaces}#{@display_month}#{MONTH_LABEL}\s#{@display_year}
    #{DAYS}
    #{first_week_spaces}#{dates}
    EOF
  end
end
