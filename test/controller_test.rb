require_relative 'test_helper'
require './lib/controller'

describe Controller do
  it "starts out with an open TCPServer" do
    controller = Controller.new
    assert controller.server
    refute controller.server.closed?
  end
end
