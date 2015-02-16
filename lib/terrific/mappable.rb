require "terrific/error"

module Terrific
  module Mappable
    extend ActiveSupport::Concern

    included do
      map_error "Exception", to: :internal_server_error, type: :server_error
      map_error "ActiveRecord::RecordNotFound", to: :not_found
      map_error "ActiveRecord::RecordInvalid", to: :unprocessable_entity
    end

    module ClassMethods
      def map_error(*klasses, options)
        rescue_from *klasses do |exception|
          status = options.fetch(:to)
          error = Error.new(exception, options.slice(:type, :message))
          render status: status, json: { error: error }
        end
      end
    end
  end
end

if ActionController.const_defined?("API")
  ActionController::API
else
  ActionController::Base
end.send(:include, Terrific::Mappable)
