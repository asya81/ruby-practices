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

  counts = read_files
  counts << total(counts) if counts.size > 1
  puts format_counts(counts, options)
end

def read_files
  counts = []
  row = Hash.new(0)
  ARGF.each do |line|
    row[:lines] += 1
    row[:words] += line.split.size
    row[:bytes] += line.bytesize
    next unless ARGF.file.eof?

    path = $stdin.tty? ? ARGF.file.path : ''
    row[:path] = path
    counts << row
    row = Hash.new(0)
  end
  counts
end

def total(counts)
  {
    lines: counts.sum { |count| count[:lines] },
    words: counts.sum { |count| count[:words] },
    bytes: counts.sum { |count| count[:bytes] },
    path: 'total'
  }
end

def format_counts(counts, options)
  counts.map do |count|
    count.map do |option, value|
      if option == :path
        value.empty? ? '' : " #{value}"
      else
        options[option] ? value.to_s.rjust(8) : ''
      end
    end.join
  end
end

output if __FILE__ == $PROGRAM_NAME
