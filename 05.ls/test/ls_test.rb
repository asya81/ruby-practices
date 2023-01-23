# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  def test_ls_0_objects
    Dir.stub(:glob, %w[]) do
      assert_output('') { main }
    end
  end

  def test_ls_1_object
    assert_equal "1\n", simple_format_objects(%w[1])
  end

  def test_ls_2_object
    assert_equal "1       2\n", simple_format_objects(%w[1 2])
  end

  def test_ls_3_objects
    assert_equal "1       2       3\n", simple_format_objects(%w[1 2 3])
  end

  def test_ls_4_objects
    assert_equal "1       3\n2       4\n", simple_format_objects(%w[1 2 3 4])
  end

  def test_ls_5_objects
    assert_equal "1       3       5\n2       4\n", simple_format_objects(%w[1 2 3 4 5])
  end

  def test_ls_6_objects
    assert_equal "1       3       5\n2       4       6\n", simple_format_objects(%w[1 2 3 4 5 6])
  end

  def test_ls_7_objects
    assert_equal "1       4       7\n2       5\n3       6\n", simple_format_objects(%w[1 2 3 4 5 6 7])
  end

  def test_ls_objects_with_dot_match
    assert_equal ".               .gitkeep        test\n..              lib\n", simple_format_objects(%w[. .. .gitkeep lib test])
  end

  def test_ls_long_name_objects
    object_names = %w[01.fizzbuzz 02.calendar 03.rake 04.bowling 05.ls 06.wc 07.bowling_object 08.ls_object 09.wc_object README.md]
    expected = <<~OUTPUT
      01.fizzbuzz             05.ls                   09.wc_object
      02.calendar             06.wc                   README.md
      03.rake                 07.bowling_object
      04.bowling              08.ls_object
    OUTPUT
    assert_equal expected, simple_format_objects(object_names)
  end

  def test_ls_l_option
    FileUtils.cd('l_option')
    expected = <<~"OUTPUT"
      total 16
      drwxr-xr-x  3 asya      staff      96 Mar 25 23:44 sample
      -rw-r--r--  1 asya81jp  everyone    5 Mar 25 23:06 test.txt
      -rw-r--r--  1 asya      staff     241 Mar 25 23:32 test_for_long_file_name.txt
    OUTPUT

    object_names = %w[sample test.txt test_for_long_file_name.txt]
    assert_equal expected, long_format_objects(object_names)
  end

  def test_ls_r_option
    assert_equal %w[test lib], glob_objects({ 'r' => true })
  end
end
