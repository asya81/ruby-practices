#!/usr/bin/env ruby
require 'optparse'
options = ARGV.getopts('y:', 'm:')
input_year = options["y"]  # TODO: yオプションが指定されなかった場合の考慮が必要
input_month = options["m"]  # TODO: mオプションが指定されなかった場合の考慮が必要

puts(<<EOF)
      #{input_month}月 #{input_year}         
日 月 火 水 木 金 土  
          1  2  3  4  
 5  6  7  8  9 10 11  
12 13 14 15 16 17 18  
19 20 21 22 23 24 25  
26 27 28 29 30
EOF

# 出力結果のイメージ（yに2022、mに6を指定した場合）
#       6月 2022
# 日 月 火 水 木 金 土
#           1  2  3  4
#  5  6  7  8  9 10 11
# 12 13 14 15 16 17 18
# 19 20 21 22 23 24 25
# 26 27 28 29 30
