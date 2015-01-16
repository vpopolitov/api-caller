module ApiCaller
  class Request
    attr_reader :http_verb, :url, :body

    def initialize(http_verb, url, body = {})
      @http_verb = http_verb
      @url = url
      @body = body
    end
  end
end