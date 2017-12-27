require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require './lib/server'

describe Server do
  it "runs" do
    assert_equal 6, 2 * 3
  end
end
