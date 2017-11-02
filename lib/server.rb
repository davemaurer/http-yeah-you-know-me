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
    client.puts response_headers
    respond_with_hello(client) if @headers[:verb] == "GET" && @headers[:path] == "/hello"
    respond_with_root_info(client) if @headers[:verb] == "GET" && @headers[:path] == "/"
  end

  def response_headers
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: 55\r\n\r\n"].join("\r\n")
  end

  def respond_with_root_info(client)
    client.puts debugging_output
  end

  def respond_with_hello(client)
    @hello_counter += 1
    client.puts "<html><head></head><body><h1>Hello World, Count: #{@hello_counter}</h1></body></html>"
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
    @headers[:accept]   = lines[6][1]
  end

end

server = Server.new
server.start
