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
  l = 0
  w = 0
  c = 0
  ARGF.each do |line|
    l += 1
    w += line.split.size
    c += line.bytesize
    next unless ARGF.file.eof?

    counts << { lines: l, words: w, bytes: c, path: $stdin.tty? ? ARGF.file.path : nil }
    l = 0
    w = 0
    c = 0
  end
  counts
end

def format_file(wc_options, counts)
  output = []
  counts.each do |count|
    wc_options.each_key do |key|
      output << format_as_tab(count[key]) if selected_option?(wc_options, key)
    end
    output << " #{count[:path]}" unless count[:path].nil?
    output << "\n"
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
  "#{format_as_tab(l_total)}#{format_as_tab(w_total)}#{format_as_tab(c_total)} total\n"
end

def format_as_tab(num)
  num.to_s.rjust(8)
end

print wc_output if __FILE__ == $PROGRAM_NAME
