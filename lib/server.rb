require 'socket'
require_relative '../lib/request'

class Server
  def initialize
    @server = TCPServer.new(3000)
    @listening = true
    @hello_counter = 0
  end

  def start
    while @listening
      client = @server.accept
      request = Request.new(client)
      handle_request(request.client)
    end
  end

  def handle_request(request)
    debugging_info = request.debugging_info
    respond_with_hello(request.client, debugging_info) if request.hello_path?
    respond_with_root_info(request.client, debugging_info) if request.root_path?
    respond_with_date(request.client, debugging_info) if request.datetime_path?
  end

  def response_headers(length)
    ["http/1.1 200 ok",
     "date: #{current_date_for_headers}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{length}\r\n\r\n"].join("\r\n")
  end

  def respond_with_date(client, debugging_info)
    view = View.new(current_time_for_view, debugging_info)
    client.puts response_headers(view.body_length)
    client.puts view.response_html
  end

  def respond_with_root_info(client, debugging_info)
    view = View.new(debugging_output(header_values), debugging_info)
    client.puts response_headers(view.body_length)
    client.puts view.response_html
  end

  def respond_with_hello(client, debugging_info)
    @hello_counter += 1
    body = "Hello World! - Count: #{@hello_counter}"
    view = View.new(body, debugging_info)
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
