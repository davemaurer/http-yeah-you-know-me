require 'socket'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @listening = true
    @hello_counter = 0
    @headers = {}
  end

  def start
    while @listening do
      client = @server.accept
      handle_request(client)
    end
  end

  def handle_request(client)
    build_request_headers(client)
    respond_with_hello(client) if @headers[:verb] == "GET" && @headers[:path] == "/hello"
    respond_with_root_info(client) if @headers[:verb] == "GET" && @headers[:path] == "/"
    respond_with_date(client) if @headers[:verb] == "GET" && @headers[:path] == "/datetime"
  end

  def response_headers(body)
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{body.length}\r\n\r\n"].join("\r\n")
  end

  def respond_with_date(client)
    body = "<html><head></head><body>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</body></html>"
    client.puts response_headers(body)
    client.puts body
  end

  def respond_with_root_info(client)
    body = "<html><head></head><body>#{debugging_output}</body></html>"
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

  def parse_request(client)
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
    lines = parse_request(client)
    @headers[:verb]     = lines[0][0]
    @headers[:path]     = lines[0][1]
    @headers[:protocol] = lines[0][2]
    @headers[:host]     = lines[1][1]
    @headers[:port]     = lines[1][1][-4..-1]
    @headers[:origin]   = lines[1][1]
    @headers[:accept]   = lines.find { |line| line[0] == "Accept:" }[1]
  end

end

server = Server.new
server.start
