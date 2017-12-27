class Request
  attr_reader :verb, :path, :protocol, :host,
              :port, :origin, :accept

  def initialize(client)
    @request_lines = request_lines(client)
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
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protocol}
      Host: #{host}
      Port: #{port}
      Origin: #{origin}
      Accept: #{accept}
     </pre>"
  end

  def verb
    @request_lines[0][0]
  end

  def path
    @request_lines[0][1]
  end

  def protocol
    @request_lines[0][2]
  end

  def host
    @request_lines[1][1]
  end

  def port
    @request_lines[1][1][-4..-1]
  end

  def origin
    @request_lines[1][1]
  end

  def accept
    @request_lines.find {|line| line[0] == "Accept:"}[1]
  end

  def hello_path?
    verb == "GET" && path == "/hello"
  end

  def root_path?
    verb == "GET" && path == "/"
  end

  def datetime_path?
    verb == "GET" && path == "/datetime"
  end
end
