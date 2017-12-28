require_relative 'test_helper'
require './lib/server'

describe Server do
  it "runs" do
    assert_equal 6, 2 * 3
  end
end
