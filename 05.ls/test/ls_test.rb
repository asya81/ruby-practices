# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  def test_ls_0_files
    Dir.stub(:glob, %w[]) do
      assert_nil main
    end
  end

  def test_ls_1_file
    assert_equal "1\n", list_objects(%w[1])
  end

  def test_ls_3_files
    assert_equal "1       2       3\n", list_objects(%w[1 2 3])
  end

  def test_ls_4_files
    assert_equal "1       3\n2       4\n", list_objects(%w[1 2 3 4])
  end

  def test_ls_5_files
    assert_equal "1       3       5\n2       4       \n", list_objects(%w[1 2 3 4 5])
  end

  def test_ls_9_files
    assert_equal "1       4       7\n2       5       8\n3       6       9\n", list_objects(%w[1 2 3 4 5 6 7 8 9])
  end

  def test_ls_10_files
    assert_equal "1       4       8\n10      5       9\n2       6       \n3       7       \n", list_objects(%w[1 10 2 3 4 5 6 7 8 9])
  end

  def test_ls_long_name_files
    file_names = %w[01.fizzbuzz 02.calendar 03.rake 04.bowling 05.ls 06.wc 07.bowling_object 08.ls_object 09.wc_object README.md]
    expected = <<~OUTPUT
      01.fizzbuzz             05.ls                   09.wc_object
      02.calendar             06.wc                   README.md
      03.rake                 07.bowling_object       
      04.bowling              08.ls_object            
    OUTPUT
    assert_equal expected, list_objects(file_names)
  end
end
