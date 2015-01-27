module ApiCaller
  module Error
    class CallerError < StandardError
    end

    class MissingService < CallerError
    end

    class MissingRoute < CallerError
    end

    class MissingRouteName < CallerError
    end
  end
end