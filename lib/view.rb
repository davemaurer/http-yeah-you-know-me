class View
  def initialize(view_body, debugging_info)
    @view_body = view_body
    @debugging_info = debugging_info
  end

  def response_html
    @debugging_info
    "<html><head></head><body>#{@view_body}</body></html>"
  end

  def body_length
    @view_body.length
  end

  def debugging_output
    info = @debugging_info
    "<pre>
      Verb: #{info[:verb]}
      Path: #{info[:path]}
      Protocol: #{info[:protocol]}
      Host: #{info[:host]}
      Port: #{info[:port]}
      Origin: #{info[:origin]}
      Accept: #{info[:accept]}
     </pre>"
  end
end
