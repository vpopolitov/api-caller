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
        url = route.process_route(route, { base_url: base_url, params: params })
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
    end
  end
end