require_relative '../application_service'

module Account
  class Login < ApplicationService
    RETURNS = [
      SUCCESS = :success,
      WRONG_LOGIN_OR_PASS = :wrong_login_or_pass
    ]

    def initialize(login, password)
      if login.class != String || password.class != String
        raise "all params must be str"
      end

      @login = login
      @password = password
    end

    def call
      user = User.find_by(name: @login)
      if user && user.authenticate(@password)
        token = SecureRandom.urlsafe_base64 32, false
        user.token = token
        user.save
        [SUCCESS, token]
      else
        WRONG_LOGIN_OR_PASS
      end
    end
  end
end
