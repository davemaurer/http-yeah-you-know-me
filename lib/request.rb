class Request
  attr_reader :debugging_info

  def initialize(client)
    @request_lines = request_lines(client)
  end

  def request_lines(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    p request_lines.map { |l| l.split(" ") }
  end

  def debugging_info
    {
      verb: request_verb,
      path: request_path,
      protocol: request_protocol,
      host: request_host,
      port: request_port,
      origin: request_origin,
      accept: request_accept
    }
  end

  def request_verb
    @request_lines[0][0]
  end

  def request_path
    @request_lines[0][1]
  end

  def request_protocol
    @request_lines[0][2]
  end

  def request_host
    @request_lines[1][1]
  end

  def request_port
    @request_lines[1][1][-4..-1]
  end

  def request_origin
    @request_lines[1][1]
  end

  def request_accept
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
