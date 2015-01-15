require 'faraday'
require 'facets/string/snakecase'
require 'api_caller/version'
require 'api_caller/error'
require 'api_caller/adapter'
require 'api_caller/route'

module ApiCaller
  class << self
    def register(adapter_klass, params = {})
      adapter_alias = params.fetch(:as, adapter_klass.to_s.snakecase.intern)
      adapters[adapter_alias] = adapter_klass
    end

    def call(adapter_name, route_name, params = {})
      adapter = adapters[adapter_name]
      raise ApiCaller::Error::MissingAdapter unless adapter

      route = adapter.fetch_route(route_name, params)

      # base_url = 'https://api.stackexchange.com/2.2/'
      # reference = 'badges/222?order=desc&sort=rank&site=stackoverflow'
      # url = "#{base_url}#{reference}"
      #
      # conn = Faraday.new url: url do |builder|
      #   builder.response :logger
      #   builder.adapter Faraday.default_adapter
      # end
      #
      # res = conn.get do |req|
      #   req.params[:q] = 'London,ca'
      # end
      #
      # res

    end

    private

    def adapters
      @adapters ||= {}
    end
  end
end
