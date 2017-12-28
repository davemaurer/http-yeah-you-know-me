class View
  def initialize(view_body, debugging_info)
    @view_body = view_body
    @debugging_info = debugging_info
  end

  def response_html
    "<html><head></head><body>#{debugging_output + @view_body}</body></html>"
  end

  def body_length
    response_html.length
  end

  def debugging_output
    info = @debugging_info
    "<pre>\n" +
      "Verb: #{info[:verb]}\n" +
      "Path: #{info[:path]}\n" +
      "Protocol: #{info[:protocol]}\n" +
      "Host: #{info[:host]}\n" +
      "Port: #{info[:port]}\n" +
      "Origin: #{info[:origin]}\n" +
      "Accept: #{info[:accept]}\n" +
    "</pre>\n"
  end
end
