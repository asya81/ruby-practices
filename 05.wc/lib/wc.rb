#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def output
  opt = OptionParser.new
  options = { lines: false, words: false, bytes: false }
  opt.on('-l') { |v| options[:lines] = v }
  opt.on('-w') { |v| options[:words] = v }
  opt.on('-c') { |v| options[:bytes] = v }
  opt.parse!(ARGV)
  options.transform_values! { true } if options.values.none?

  counts = read_files(options)
  counts << total(counts) if counts.size > 1
  puts format_counts(counts)
end

def read_files(options)
  counts = []
  row = Hash.new(0)
  l_option = options[:lines]
  w_option = options[:words]
  c_option = options[:bytes]
  ARGF.each do |line|
    row[:l] += 1 if l_option
    row[:w] += line.split.size if w_option
    row[:c] += line.bytesize if c_option
    next unless ARGF.file.eof?

    path = $stdin.tty? ? ARGF.file.path : ''
    row[:path] = path
    counts << row
    row = Hash.new(0)
  end
  counts
end

def total(counts)
  row = {}
  counts[0].each_key do |option|
    next if option == :path

    row[option] = counts.sum { |count| count[option] }
  end
  row[:path] = 'total'
  row
end

def format_counts(counts)
  counts.map do |count|
    count.map do |option, value|
      if option == :path
        value.empty? ? '' : " #{value}"
      else
        value.to_s.rjust(8)
      end
    end.join
  end
end

output if __FILE__ == $PROGRAM_NAME
