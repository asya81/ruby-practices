# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  def setup
    @wd = FileUtils.pwd
    @test_updated = 'Sep 24 20:52'
    @lib_updated = 'Sep 24 01:17'
    @alr_expected = <<~"OUTPUT"
      total 0
      drwxr-xr-x  12 asya  staff  384 #{@test_updated} test
      drwxr-xr-x   3 asya  staff   96 #{@lib_updated} lib
      -rw-r--r--   1 asya  staff    0 Aug 22 00:08 .gitkeep
      drwxr-xr-x  17 asya  staff  544 Aug 22 00:11 ..
      drwxr-xr-x   5 asya  staff  160 Sep  1 22:36 .
    OUTPUT
  end

  def teardown
    FileUtils.cd(@wd)
  end

  def test_ls_0_objects
    FileUtils.cd("#{@wd}/test/0_objects")
    assert_equal '', `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_1_object
    FileUtils.cd("#{@wd}/test/1_object")
    assert_equal "1\n", `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_2_object
    FileUtils.cd("#{@wd}/test/2_objects")
    assert_equal "1       2\n", `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_3_objects
    FileUtils.cd("#{@wd}/test/3_objects")
    assert_equal "1       2       3\n", `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_4_objects
    FileUtils.cd("#{@wd}/test/4_objects")
    assert_equal "1       3\n2       4\n", `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_5_objects
    FileUtils.cd("#{@wd}/test/5_objects")
    assert_equal "1       3       5\n2       4\n", `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_6_objects
    FileUtils.cd("#{@wd}/test/6_objects")
    assert_equal "1       3       5\n2       4       6\n", `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_7_objects
    FileUtils.cd("#{@wd}/test/7_objects")
    assert_equal "1       4       7\n2       5\n3       6\n", `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_objects_with_dot_match
    assert_equal ".               .gitkeep        test\n..              lib\n", `ruby #{@wd}/lib/ls.rb -a`
  end

  def test_ls_long_name_objects
    FileUtils.cd("#{@wd}/test/long_name_objects")
    expected = <<~OUTPUT
      01.fizzbuzz             05.ls                   09.wc_object
      02.calendar             06.wc                   README.md
      03.rake                 07.bowling_object
      04.bowling              08.ls_object
    OUTPUT
    assert_equal expected, `ruby #{@wd}/lib/ls.rb`
  end

  def test_ls_l_option
    expected = <<~"OUTPUT"
      total 0
      drwxr-xr-x   3 asya  staff   96 #{@lib_updated} lib
      drwxr-xr-x  12 asya  staff  384 #{@test_updated} test
    OUTPUT
    assert_equal expected, `ruby #{@wd}/lib/ls.rb -l`
  end

  def test_ls_r_option
    FileUtils.cd("#{@wd}/test/3_objects")
    assert_equal "3       2       1\n", `ruby #{@wd}/lib/ls.rb -r`
  end

  def test_ls_a_l_option
    expected = <<~"OUTPUT"
      total 0
      drwxr-xr-x   5 asya  staff  160 Sep  1 22:36 .
      drwxr-xr-x  17 asya  staff  544 Aug 22 00:11 ..
      -rw-r--r--   1 asya  staff    0 Aug 22 00:08 .gitkeep
      drwxr-xr-x   3 asya  staff   96 #{@lib_updated} lib
      drwxr-xr-x  12 asya  staff  384 #{@test_updated} test
    OUTPUT
    assert_equal expected, `ruby #{@wd}/lib/ls.rb -al`
  end

  def test_ls_a_r_option
    assert_equal "test            .gitkeep        .\nlib             ..\n", `ruby #{@wd}/lib/ls.rb -ar`
  end

  def test_ls_l_r_option
    expected = <<~"OUTPUT"
      total 0
      drwxr-xr-x  12 asya  staff  384 #{@test_updated} test
      drwxr-xr-x   3 asya  staff   96 #{@lib_updated} lib
    OUTPUT
    assert_equal expected, `ruby #{@wd}/lib/ls.rb -lr`
  end

  def test_ls_a_r_l_option
    assert_equal @alr_expected, `ruby #{@wd}/lib/ls.rb -arl`
  end

  def test_ls_r_l_a_option
    assert_equal @alr_expected, `ruby #{@wd}/lib/ls.rb -rla`
  end

  def test_ls_l_r_a_option
    assert_equal @alr_expected, `ruby #{@wd}/lib/ls.rb -lra`
  end
end
