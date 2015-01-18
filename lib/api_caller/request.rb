module ApiCaller
  Request = Struct.hash_initialized :http_verb, :url, :body, :headers

  # class Request
    # attr_reader :http_verb, :url, :body

    # def initialize(context)
    #   @http_verb = http_verb
    #   @url = url
    #   @body = body
    # end
  # end
end