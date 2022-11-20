# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  def test_main
    assert_equal "lib     test    tmp\n", main
  end
end
