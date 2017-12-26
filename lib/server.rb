require 'socket'
require '../lib/request'

class Server
  attr_accessor :headers

  def initialize
    @server = TCPServer.new(3000)
    @listening = true
    @hello_counter = 0
    @headers = nil
  end

  def start
    while @listening
      client = @server.accept
      request = Request.new(client)
      handle_request(request, headers)
    end
  end

  def handle_request(request, headers)
    verb = headers[:verb]
    path = headers[:path]
    respond_with_hello(request) if @headers[:verb] == "GET" && @headers[:path] == "/hello"
    respond_with_root_info(request) if @headers[:verb] == "GET" && @headers[:path] == "/"
    respond_with_date(request) if @headers[:verb] == "GET" && @headers[:path] == "/datetime"
  end

  def response_headers(length)
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{length}\r\n\r\n"].join("\r\n")
  end

  def respond_with_date(client)
    body = "<html><head></head><body>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</body></html>"
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

  def request_lines(client)
    request_lines = []
    line = client.gets
    until line.chomp.empty?
      request_lines << line
      line = client.gets
    end
    request_lines.map { |l| l.chomp.split(" ") }
  end

  def debugging_output
    "<pre>
      Verb: #{@headers[:verb]}
      Path: #{@headers[:path]}
      Protocol: #{@headers[:protocol]}
      Host: #{@headers[:host]}
      Port: #{@headers[:port]}
      Origin: #{@headers[:origin]}
      Accept: #{@headers[:accept]}
     </pre>"
  end

  def build_request_headers(client)
    values = Request.request_lines(client)
    add_header_values(values)
  end

  def request_header_values()

  end

  def add_header_values(lines)
    {
      verb: lines[0][0],
      path: lines[0][1],
      protocol: lines[0][2],
      host: lines[1][1],
      port: lines[1][1][-4..-1],
      origin: lines[1][1],
      accept: lines.find { |line| line[0] == "Accept:" }[1]
    }
  end
end

server = Server.new
server.start
