require 'addressable/uri'
require 'addressable/template'
require 'faraday'
require 'facets/string/snakecase'
require 'api_caller/extensions/enumerable'
require 'api_caller/extensions/struct'
require 'api_caller/service'
require 'api_caller/context'
require 'api_caller/decorator'
require 'api_caller/error'
require 'api_caller/route'
require 'api_caller/request'
require 'api_caller/version'

module ApiCaller
  class << self
    attr_reader :http_adapter

    def register(service_klass, params = {})
      service_alias = params.fetch(:as, service_klass.to_s.snakecase.intern)
      services[service_alias] = service_klass
    end

    def call(service_name, route_name, params = {})
      service = services[service_name]
      raise ApiCaller::Error::MissingService unless service

      request = service.build_request(route_name, params)
      response = service.build_response(request)
      response
    end

    def use_http_adapter(http_adapter)
      @http_adapter = http_adapter
    end

    private

    def services
      @services ||= {}
    end
  end
end
