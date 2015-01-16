module ApiCaller
  class Adapter
    class << self
      def use_base_url(url)
        @base_url = url
      end

      def get(url_pattern, params = {})
        route_name = params[:as]
        raise ApiCaller::Error::MissingRouteName, route_name unless route_name
        routes[route_name] = Route.new pattern: url_pattern, http_verb: :get
      end

      def build_request(route_name, params = {})
        route = routes[route_name]
        raise ApiCaller::Error::MissingRoute, route_name unless route
        url = process_route(route, params)
        Request.new(route.http_verb, url)
      end

      def configure(&block)
        class_eval &block if block_given?
      end

      private

      def routes
        @routes ||= {}
      end

      def base_url
        @base_url ||= ''
      end

      def url_pattern
        /(?<sep>&)?((?<key>\w+)=)?:(?<val>\w+)/
      end

      def process_route(route, params = {})
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
    end
  end
end