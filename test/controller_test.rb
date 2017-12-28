require_relative 'test_helper'
require './lib/controller'

describe Controller do
  it "starts out with an open TCPServer" do
    controller = Controller.new
    assert controller.server
    assert controller.server.instance_of?(TCPServer)
    refute controller.server.closed?
  end
end
