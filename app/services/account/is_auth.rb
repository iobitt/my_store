require_relative '../application_service'


module Account
  class IsAuth < ApplicationService

    def initialize(token)
      @token = token
    end

    def call
      return false if @token.class != String

      u = User.find_by(token: @token)
      u ? u : false
    end
  end
end
