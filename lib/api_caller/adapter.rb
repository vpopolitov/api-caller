module ApiCaller
  class Adapter
    class << self
      def get(url_pattern, params = {})
        route_name = params[:as]
        raise ApiCaller::Error::MissingRouteName, route_name unless route_name
        routes[route_name] = Route.new pattern: url_pattern, http_verb: :get
      end

      def fetch_route(route_name, params = {})
        route = routes[route_name]
        raise ApiCaller::Error::MissingRoute, route_name unless route
        route
      end

      private

      def routes
        @routes ||= {}
      end
    end
  end
end