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
  l_total, w_total, c_total = [0, 0, 0]
  multiple_files = ARGV.size > 1 ? true : false
  while argv = ARGV.shift
    File.open(argv) do |file|
      l, w, c = [0, 0, 0]
      while line = file.gets
        l += 1
        w += line.split.size
        c += line.bytesize
      end
      output = []
      if params[:lines] || with_no_options?(params)
        output << l.to_s.rjust(8)
      end
      if params[:words] || with_no_options?(params)
        output << w.to_s.rjust(8)
      end
      if params[:bytes] || with_no_options?(params)
        output << c.to_s.rjust(8)
      end
      output << " #{file.path}\n"
      total_output << output.join
      l_total += l
      w_total += w
      c_total += c
    end
  end
  if multiple_files
    total_output << "#{l_total.to_s.rjust(8)}#{w_total.to_s.rjust(8)}#{c_total.to_s.rjust(8)} total\n"
  end
  total_output.join
end

def wc_output_with_pipe
  l, w, c = [0, 0, 0]
  ARGF.each_line do |line|
    l += 1
    w += line.split.size
    c += line.bytesize
  end
  "#{l.to_s.rjust(8)}#{w.to_s.rjust(8)}#{c.to_s.rjust(8)}\n"
end

def with_no_options?(params)
  if params.values.all?{ |v| v == false }
    true
  else
    false
  end
end

if __FILE__ == $0
  # ターミナルから実行した場合
  if STDIN.tty?
    print wc_output
  else
    # パイプにつながっている場合
    print wc_output_with_pipe
    # print "       3       3      34\n"
  end
end
