module ApiCaller
  class Decorator
    def initialize(route_name = :all)
      @route_name = route_name
    end

    def execute(request, route_name)
      wrap request if [route_name, :all].include? @route_name
    end

    private

    def wrap(request)
      request
    end
  end
end