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

      body = "<html><head></head><body><h1>Hello World, Count: #{counter}</h1></body></html>"
      client.puts ["http/1.1 200 ok",
        "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
        "server: ruby",
        "content-type: text/html; charset=iso-8859-1",
        "content-length: 55\r\n\r\n"].join("\r\n")
      client.puts body
    end
  end

  def handle_request(client)
    build_request_headers(client)
    
  end

  def parse_request(client)
    request_lines = []
    line = client.gets
    until line.chomp.empty?
      request_lines << line
      line = client.gets
    end
    request_lines.map { |line| line.chomp.split(" ") }
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
