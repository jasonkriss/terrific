module Terrific
  class Error
    attr_accessor :exception

    def initialize(exception, options = {})
      @exception = exception
      @inner_type = options.fetch(:type, default_type)
      @inner_message = options.fetch(:message, default_message)
    end

    def type
      @type ||= apply(inner_type)
    end

    def message
      @message ||= apply(inner_message)
    end

    def as_json(options = {})
      { type: type, message: message }
    end

    private
    attr_reader :inner_type, :inner_message

    def apply(inner)
      if inner.respond_to?(:call)
        inner.call(exception)
      else
        inner
      end
    end

    def default_type
      exception.class.name.split("::").last.underscore
    end

    def default_message
      I18n.t(type, scope: [:terrific, :messages], default: exception.message)
    end
  end
end
