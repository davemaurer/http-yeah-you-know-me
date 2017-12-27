require 'socket'
require_relative '../lib/request'

class Server
  attr_accessor :headers

  def initialize
    @server = TCPServer.new(3000)
    @listening = true
    @hello_counter = 0
  end

  def start
    while @listening
      client = @server.accept
      request = Request.new(client)
      handle_request(request)
    end
  end

  def handle_request(request)
    respond_with_hello(request) if request.hello_path?
    respond_with_root_info(request) if request.root_path?
    respond_with_date(request) if request.datetime_path?
  end

  def response_headers(length)
    ["http/1.1 200 ok",
     "date: #{current_date_for_headers}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{length}\r\n\r\n"].join("\r\n")
  end

  def respond_with_date(client)
    body = "<html><head></head><body>#{current_time_for_view}</body></html>"
    client.puts response_headers(body.length)
    client.puts body
  end

  def respond_with_root_info(client)
    body = "<html><head></head><body>#{debugging_output(header_values)}</body></html>"
    client.puts response_headers(body)
    client.puts body
  end

  def respond_with_hello(client)
    @hello_counter += 1
    body = "<html><head></head><body><h1>Hello World, " \
           "Count: #{@hello_counter}</h1></body></html>"
    client.puts response_headers(body)
    client.puts body
  end

  def current_time_for_view
    Time.now.strftime('%H:%M%p on %A, %B %e, %Y')
  end

  def current_date_for_headers
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end
end
