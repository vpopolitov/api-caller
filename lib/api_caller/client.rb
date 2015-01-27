module ApiCaller
  class Client
    def initialize(http_adapter)
      @http_adapter = http_adapter
    end

    def build_response(request)
      @http_adapter.send(request.http_verb, request.url) do |_|
        # TODO:: post, put
        #req.params[:q] = 'London,ca'
      end
    end
  end
end