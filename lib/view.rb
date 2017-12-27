class View
  attr_reader :body
  def initialize(body)
    @body = body
  end

  def response
    "<html><head></head><body>#{body}</body></html>"
  end

  def body_length
    body.length
  end
end
