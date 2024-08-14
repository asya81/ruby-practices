#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def wc_output
  opt = OptionParser.new
  wc_options = { lines: false, words: false, bytes: false }
  opt.on('-l') { |v| wc_options[:lines] = v }
  opt.on('-w') { |v| wc_options[:words] = v }
  opt.on('-c') { |v| wc_options[:bytes] = v }
  opt.parse!(ARGV)

  counts_by_file = read_files
  total_by_file = format_file(wc_options, counts_by_file)
  total_of_files = format_total(counts_by_file) if counts_by_file.size > 1
  [total_by_file, total_of_files].join
end

def read_files
  counts = []
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
      counts << { lines: l, words: w, bytes: c, path: file.path }
    end
  end
  counts
end

def format_file(wc_options, counts)
  output = []
  counts.each do |count|
    wc_options.each_key do |key|
      output << count[key].to_s.rjust(8) if selected_option?(wc_options, key)
    end
    output << " #{count[:path]}\n"
  end
  output.join
end

def selected_option?(params, option)
  params[option] || params.values.all? { |v| v == false }
end

def format_total(counts)
  l_total = counts.sum { |count| count[:lines] }
  w_total = counts.sum { |count| count[:words] }
  c_total = counts.sum { |count| count[:bytes] }
  "#{l_total.to_s.rjust(8)}#{w_total.to_s.rjust(8)}#{c_total.to_s.rjust(8)} total\n"
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

if __FILE__ == $PROGRAM_NAME
  if $stdin.tty?
    print wc_output
  else
    print wc_output_with_pipe
  end
end
