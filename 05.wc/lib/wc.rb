#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def wc_output
  opt = OptionParser.new
  params = { lines: false, words: false, bytes: false }
  opt.on('-l') { |v| params[:lines] = v }
  opt.on('-w') { |v| params[:words] = v }
  opt.on('-c') { |v| params[:bytes] = v }
  opt.parse!(ARGV)

  total_output = []
  l_total = 0
  w_total = 0
  c_total = 0
  multiple_files = ARGV.size > 1
  while (argv = ARGV.shift)
    File.open(argv) do |file|
      l = 0
      w = 0
      c = 0
      while (line = file.gets)
        l += 1
        w += line.split.size
        c += line.bytesize
      end
      output = []
      output << l.to_s.rjust(8) if params[:lines] || with_no_options?(params)
      output << w.to_s.rjust(8) if params[:words] || with_no_options?(params)
      output << c.to_s.rjust(8) if params[:bytes] || with_no_options?(params)
      output << " #{file.path}\n"
      total_output << output.join
      l_total += l
      w_total += w
      c_total += c
    end
  end
  total_output << "#{l_total.to_s.rjust(8)}#{w_total.to_s.rjust(8)}#{c_total.to_s.rjust(8)} total\n" if multiple_files
  total_output.join
end

def wc_output_with_pipe
  l = 0
  w = 0
  c = 0
  ARGF.each_line do |line|
    l += 1
    w += line.split.size
    c += line.bytesize
  end
  "#{l.to_s.rjust(8)}#{w.to_s.rjust(8)}#{c.to_s.rjust(8)}\n"
end

def with_no_options?(params)
  if params.values.all? { |v| v == false }
    true
  else
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  # ターミナルから実行した場合
  if $stdin.tty?
    print wc_output
  else
    # パイプにつながっている場合
    print wc_output_with_pipe
    # print "       3       3      34\n"
  end
end
