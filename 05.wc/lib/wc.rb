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

  counts = read_files(wc_options)
  append_total(counts) if counts.size > 1
  format_counts(counts)
end

def read_files(options)
  counts = []
  row = Hash.new(0)
  ARGF.each do |line|
    row[:l] += 1 if options[:lines]
    row[:w] += line.split.size if options[:words]
    row[:c] += line.bytesize if options[:bytes]
    next unless ARGF.file.eof?

    path = $stdin.tty? ? ARGF.file.path : ''
    row[:path] = path
    counts << row
    row = Hash.new(0)
  end
  counts
end

def append_total(counts)
  total_row = Hash.new(0)
  counts[0].each_key do |option|
    next if option == :path

    total_row[option] = counts.sum { |count| count[option] }
  end
  total_row[:path] = 'total'
  counts << total_row
end

def format_counts(counts)
  counts.map do |count|
    count.map do |option, value|
      if option == :path
        format_path(value)
      else
        format_num(value)
      end
    end.join
  end
end

def format_num(num)
  num.to_s.rjust(8)
end

def format_path(path)
  path.empty? ? '' : " #{path}"
end

puts wc_output if __FILE__ == $PROGRAM_NAME
