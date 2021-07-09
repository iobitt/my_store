module Account
  class LoginService

    def initialize(name, password)
      if !name.is_a?(String) || !password.is_a?(String)
        raise "all params must be str"
      end

      @name = name
      @password = password
    end

    def call
      user = User.find_by_name(@name)
      if user && user.authenticate(@password)
        [true, user, nil]
      else
        [false, nil, ["не верный логин или пароль"]]
      end
    end
  end
end
