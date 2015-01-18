module ApiCaller
  class Route
    attr_reader :pattern, :http_verb

    def initialize(params)
      @pattern = params[:pattern]
      @http_verb  = params[:http_verb]
    end

    def process_route(route, context = {})
      params  = context[:params]
      base_url = context[:base_url]

      pattern = route.pattern
      url = pattern.gsub(url_pattern) do
        val = $~[:val].to_sym
        key = $~[:key]
        sep = $~[:sep]
        query_param = params.delete val

        if key
          if query_param
            "#{sep}#{key}=#{query_param}"
          else
            ''
          end
        else
          if query_param
            query_param
          else
            raise ApiCaller::Error::MissingResourceParameterValue, val
          end
        end
      end
      base_url.empty? ? url : "#{base_url}/#{url}"
    end

    private

    def url_pattern
      /(?<sep>&)?((?<key>\w+)=)?:(?<val>\w+)/
    end
  end
end