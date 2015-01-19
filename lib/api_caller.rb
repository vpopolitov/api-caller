require 'addressable/uri'
require 'addressable/template'
require 'faraday'
require 'facets/string/snakecase'
require 'api_caller/extensions/enumerable'
require 'api_caller/extensions/struct'
require 'api_caller/adapter'
require 'api_caller/context'
require 'api_caller/error'
require 'api_caller/route'
require 'api_caller/request'
require 'api_caller/version'

module ApiCaller
  class << self
    attr_writer :http_adapter

    def register(adapter_klass, params = {})
      adapter_alias = params.fetch(:as, adapter_klass.to_s.snakecase.intern)
      adapters[adapter_alias] = adapter_klass
    end

    def call(adapter_name, route_name, params = {})
      adapter = adapters[adapter_name]
      raise ApiCaller::Error::MissingAdapter unless adapter

      request = adapter.build_request(route_name, params)
      res = @http_adapter.send(request.http_verb, request.url) do |_|
        # TODO:: post, put
        #req.params[:q] = 'London,ca'
      end

      res
    end

    private

    def adapters
      @adapters ||= {}
    end

    def http_adapter
      @http_adapter ||= Faraday.new do |builder|
        builder.response :logger
        builder.adapter Faraday.default_adapter
      end
    end
  end
end
