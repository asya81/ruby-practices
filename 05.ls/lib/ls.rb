#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COL_COUNT = 3
TAB_SIZE = 8

def main
  options = ARGV.getopts('alr')
  wd_object_names = glob_objects(options)
  if wd_object_names.empty?
    print ''
  elsif options['l']
    print long_format_objects(wd_object_names)
  else
    print simple_format_objects(wd_object_names)
  end
end

def glob_objects(options)
  case 
  when options['a']
    Dir.glob('*', File::FNM_DOTMATCH)
  when options['r']
    Dir.glob('*').reverse
  else
    Dir.glob('*')
  end
end

def simple_format_objects(object_names)
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

def long_format_objects(object_names)
  object_states = object_details(object_names)
  max_link_length = object_states.max_by { |object| object[:link].length }[:link].length
  max_owner_length = object_states.max_by { |object| object[:owner].length }[:owner].length
  max_owner_group_length = object_states.max_by { |object| object[:owner_group].length }[:owner_group].length
  max_size_length = object_states.max_by { |object| object[:size].length }[:size].length
  display_array = ["total #{object_states.map { |o| o[:block] }.sum}\n"]
  object_states.each do |object_state|
    display_array << object_state[:file_type]
    display_array << "#{object_state[:file_mode]}  "
    display_array << "#{object_state[:link].to_s.rjust(max_link_length)} "
    display_array << "#{object_state[:owner].to_s.ljust(max_owner_length)}  "
    display_array << "#{object_state[:owner_group].to_s.ljust(max_owner_group_length)}  "
    display_array << "#{object_state[:size].to_s.rjust(max_size_length)} "
    display_array << "#{object_state[:timestamp]} "
    display_array << object_state[:name]
    display_array << "\n"
  end
  display_array.join
end

def object_details(object_names)
  object_names.map do |object_name|
    file_stat = File.stat(object_name)
    {
      block: file_stat.blocks,
      file_type: ftype_initial(file_stat),
      file_mode: permission(file_stat),
      link: file_stat.nlink.to_s,
      owner: Etc.getpwuid(file_stat.uid).name,
      owner_group: Etc.getgrgid(file_stat.gid).name,
      size: file_stat.size.to_s,
      timestamp: file_stat.mtime.strftime('%b %d %H:%M'),
      name: object_name
    }
  end
end

def ftype_initial(file_stat)
  {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }[file_stat.ftype]
end

def permission(file_stat)
  file_mode = []
  file_stat.mode.to_s(2).slice(-9, 9).chars.each_slice(3) do |permissions|
    file_mode << (permissions[0] == '1' ? 'r' : '-')
    file_mode << (permissions[1] == '1' ? 'w' : '-')
    file_mode << (permissions[2] == '1' ? 'x' : '-')
  end
  file_mode.join
end

main
