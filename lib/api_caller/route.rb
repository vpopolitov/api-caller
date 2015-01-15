module ApiCaller
  class Route
    attr_reader :http_verb

    def initialize(params)
      @pattern = params[:pattern]
      @http_verb  = params[:http_verb]
    end

    def url
      @pattern
    end

    def body
      {}
    end
  end
end