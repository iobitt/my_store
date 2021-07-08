module Account
  class RegistrationService
    USER_TYPES = %w[Manager Api]

    def initialize(type, login=nil, password=nil, password2=nil, token=nil)
      @login = login
      @password = password
      @password2 = password2
      @type = type
    end

    def call
      unless USER_TYPES.include? @type
        return [false, nil, ["не допустимый тип пользователя"]]
      end

      if @type == "Manager" && (@login.nil? || @password.nil? || @password2.nil?)
        return [false, nil, ["логин, пароль и потверждение пароля являются обязательными параметрами"]]
      end

      if @type == "Manager"
        if @password.length < 8
          return [false, nil, ["пароль должен содержать не менее 8 символов"]]
        end

        if @password != @password2
          return [false, nil, ["пароли не совпадают"]]
        end

        u = User.new(name: @login, password: @password, password_confirmation: @password2, type: @type)
      else
        u = User.new(type: @type, token: SecureRandom.urlsafe_base64(32, false))
      end

      if u.save
        [true, u, nil]
      else
        [false , nil, u.errors.full_messages]
      end
    end
  end
end
