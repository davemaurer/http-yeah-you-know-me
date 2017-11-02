require 'socket'

class Server
  def initialize
    @server = TCPServer.new(9292)
  end

  def start
    counter = 0
    loop do
      client = @server.accept
      counter += 1
      body = "<html><head></head><body><h1>Hello World, Count: #{counter}</h1></body></html>"
      client.puts ["http/1.1 200 ok",
        "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
        "server: ruby",
        "content-type: text/html; charset=iso-8859-1",
        "content-length: 55\r\n\r\n"].join("\r\n")
      client.puts body
    end
  end

  def read_request
    client = @server.accept
    request_lines = []
    line = client.gets
    until line.chomp.empty?
      request_lines << line
      line = client.gets
    end
    build_response_headers(request_lines)
    require 'pry' ; binding.pry
    request_lines
  end

  def build_response_headers(request_lines)
    lines = request_lines.map { |line| line.chomp.split(" ") }
    headers = "<pre>
                Verb: #{lines[0][0]}
                Path: #{lines[0][1]}
                Protocol: #{lines[0][2]}
                Host: #{lines[1][1]}
                Port: #{lines[1][1][-4..-1]}
                Origin: #{lines[1][1]}
                Accept: #{lines[6][1]}
               </pre>\n"
    p headers
  end

end

server = Server.new
server.start
