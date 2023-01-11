#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COL_COUNT = 3
TAB_SIZE = 8

def main
  options = ARGV.getopts('r')
  wd_object_names = glob_objects(options)
  return '' if wd_object_names.empty?

  print list_objects(wd_object_names)
end

def glob_objects(options)
  options['r'] ? Dir.glob('*').reverse : Dir.glob('*')
end

def list_objects(object_names)
  row_count = (object_names.size / COL_COUNT.to_f).ceil
  horizontal_array = []
  object_names.each_slice(row_count) do |list|
    # 転置可能にするため、Array.newで要素数を合わせている
    horizontal_array << Array.new(row_count) { |i| list[i] }
  end
  vertical_array = horizontal_array.transpose

  max_object_name_length = object_names.max_by(&:length).length
  # ファイル名先頭から次のファイル名までの文字数
  col_length = (max_object_name_length / TAB_SIZE + 1) * TAB_SIZE

  display_array = []
  vertical_array.each do |list|
    display_array << list.map { |object| object.ljust(col_length) unless object.nil? }.join.strip
    display_array << "\n"
  end
  display_array.join
end

main
