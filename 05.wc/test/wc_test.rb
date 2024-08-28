# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'
require_relative '../../05.ls/lib/ls'

class WcTest < Minitest::Test
  def test_wc_with_l_option
    assert_equal "       5 ../test/sample.txt\n", `wc.rb -l ../test/sample.txt`
  end

  def test_wc_with_w_option
    assert_equal "       6 ../test/sample.txt\n", `wc.rb -w ../test/sample.txt`
  end

  def test_wc_with_c_option
    assert_equal "      23 ../test/sample.txt\n", `wc.rb -c ../test/sample.txt`
  end

  def test_wc_with_lw_options
    assert_equal "       5       6 ../test/sample.txt\n", `wc.rb -lw ../test/sample.txt`
  end

  def test_wc_with_wc_options
    assert_equal "       6      23 ../test/sample.txt\n", `wc.rb -wc ../test/sample.txt`
  end

  def test_wc_with_lc_options
    assert_equal "       5      23 ../test/sample.txt\n", `wc.rb -lc ../test/sample.txt`
  end

  def test_wc_with_lwc_options
    assert_equal "       5       6      23 ../test/sample.txt\n", `wc.rb -lwc ../test/sample.txt`
  end

  def test_wc_without_options
    assert_equal "       5       6      23 ../test/sample.txt\n", `wc.rb ../test/sample.txt`
  end

  def test_wc_with_two_files
    expected = <<-TEXT
       5       6      23 ../test/sample.txt
      20     255    1548 ../test/sample2.txt
      25     261    1571 total
    TEXT
    assert_equal expected, `wc.rb ../test/sample.txt ../test/sample2.txt`
  end

  def test_wc_with_ls_without_options
    # 本来のlsコマンドと繋げた場合の期待値；"       3       3      34\n"
    # 自作lsコマンドと繋げた場合の期待値を指定（本来のものとは差異あり）
    assert_equal "       1       3      43\n", `../../05.ls/lib/ls.rb | wc.rb`
  end

  def test_wc_with_ls_with_l_option
    assert_equal "       4      29     178\n", `../../05.ls/lib/ls.rb -l | wc.rb`
  end

  def test_wc_with_pipe_and_option
    assert_equal "       4      29\n", `ls -l | wc.rb -lw`
  end
end
