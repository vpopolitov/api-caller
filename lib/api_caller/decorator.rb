module ApiCaller
  class Decorator
    attr_reader :route_name

    def initialize(route_name = :all)
      @route_name = route_name
    end

    def execute(request, route_name)
      request = wrap(request) if [route_name, :all].include? @route_name
      request
    end

    private

    def wrap(request)
      request
    end
  end
end