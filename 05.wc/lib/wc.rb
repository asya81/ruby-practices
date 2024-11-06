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
  wc_options.transform_values! { true } if wc_options.values.none?

  counts_by_file = read_files
  body = format_body(counts_by_file, wc_options)
  total = format_total(counts_by_file, wc_options) if counts_by_file.size > 1
  [body, total].join("\n")
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

    path = $stdin.tty? ? ARGF.file.path : ''
    counts << { lines: l, words: w, bytes: c, path: path }
    l = 0
    w = 0
    c = 0
  end
  counts
end

def format_body(counts, wc_options)
  counts.map do |count|
    row_data = wc_options.map do |key, flag|
      format_as_tab(count[key]) if flag
    end.join
    row_data << " #{count[:path]}" unless count[:path].empty?
    row_data
  end
end

def format_total(counts, wc_options)
  row_data = wc_options.map do |key, flag|
    sum = counts.sum { |count| count[key] }
    format_as_tab(sum) if flag
  end.join
  row_data << ' total'
  row_data
end

def format_as_tab(num)
  num.to_s.rjust(8)
end

puts wc_output if __FILE__ == $PROGRAM_NAME
