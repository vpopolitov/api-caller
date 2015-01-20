module ApiCaller
  class Adapter
    class << self
      def decorate(route_name = :all, with: ApiCaller::Decorator)
        decorators << with.new(route_name)
      end

      def remove_decorator
        decorators.clear
      end

      def use_base_url(url)
        @base_url = url
      end

      def get(url_template, params = {})
        route_name = params[:as]
        raise ApiCaller::Error::MissingRouteName, route_name unless route_name
        routes[route_name] = Route.new template: url_template, http_verb: :get
      end

      def build_request(route_name, params = {})
        route = routes[route_name]
        raise ApiCaller::Error::MissingRoute, route_name unless route

        params = decorators.inject(params) { |req, decorator| decorator.execute(req, route_name) }
        context = ApiCaller::Context.new(base_url: base_url, raw_params: params)
        route.build_request(context)
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

      def decorators
        @decorators ||= []
      end
    end
  end
end