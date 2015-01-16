module ApiCaller
  class Route
    attr_reader :pattern, :http_verb

    def initialize(params)
      @pattern = params[:pattern]
      @http_verb  = params[:http_verb]
    end
  end
end