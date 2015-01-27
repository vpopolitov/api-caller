module ApiCaller
  class Service
    class << self
      def decorate_request(route_name = :all, with: ApiCaller::Decorator)
        request_decorators << with.new(route_name)
      end

      def remove_request_decorators(route_name = :all)
        request_decorators.delete_if { |d| [d.route_name, :all].include? route_name }
      end

      def decorate_response(route_name = :all, with: ApiCaller::Decorator)
        response_decorators << with.new(route_name)
      end

      def remove_response_decorators(route_name = :all)
        response_decorators.delete_if { |d| [d.route_name, :all].include? route_name }
      end

      def use_base_url(url)
        @base_url = url
      end

      def use_http_adapter(http_adapter)
        @http_adapter = http_adapter
      end

      def get(url_template, params = {})
        route_name = params[:as]
        raise ApiCaller::Error::MissingRouteName, route_name unless route_name
        routes[route_name] = Route.new template: url_template, http_verb: :get
      end

      def call(route_name, params = {}, message_http_adapter = nil)
        route = routes[route_name]
        raise ApiCaller::Error::MissingRoute, route_name unless route

        params = request_decorators.inject(params) { |req, decorator| decorator.execute(req, route_name) }
        context = ApiCaller::Context.new(base_url: base_url, raw_params: params)
        req = route.build_request(context)

        res = ApiCaller::Client.new(message_http_adapter || http_adapter).build_response(req)
        res = response_decorators.inject(res) { |res, decorator| decorator.execute(res, route_name) }
        res
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

      def http_adapter
        @http_adapter ||= ApiCaller::http_adapter || Faraday.new do |builder|
          builder.response :logger
          builder.adapter Faraday.default_adapter
        end
      end

      def request_decorators
        @request_decorators ||= []
      end

      def response_decorators
        @response_decorators ||= []
      end
    end
  end
end