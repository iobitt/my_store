require_relative '../application_service'

module Account
  class Login < ApplicationService

    def initialize(login, password)
      @login = login
      @password = password
    end

    def call
      user = User.where(login: @login).first
      if user && user.password == @password
        user
      else
        false
      end
    end
  end
end
