module ApiCaller
  module Error
    class CallerError < StandardError
    end

    class MissingAdapter < CallerError
    end

    class MissingRoute < CallerError
    end

    class MissingRouteName < CallerError
    end

    class MissingResourceParameterValue < CallerError
    end
  end
end