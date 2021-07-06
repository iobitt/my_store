require_relative '../services/account/login'
require_relative '../services/account/registration'


class AccountController < ApplicationController
  layout "account"

  def login
    @token = Account::Login.call params['login'], params['password']

    if @token
      redirect_to "/"
    else
      render "account/login"
    end
  end

  def registration
    @errors = []

    unless request.method == "GET"
      if params['login'].class != String || params['password'].class != String || params['password2'].class != String
        @errors << "Все поля должны быть заполнены!"
      else
        case Account::Registration.call params['login'], params['password'], params['password2']
        when Account::Registration::SUCCESS
          return redirect_to "/account/login"
        when Account::Registration::PASSWORD_MISMATCH
          @errors << "Пароли не совпадают!"
        when Account::Registration::PASSWORD_SHORT
          @errors << "Пароль должен содержать не менее 8 символов!"
        when Account::Registration::LOGIN_SHORT
          @errors << "Логин должен содержать не менее 1 символа!"
        when Account::Registration::LOGIN_BUSY
          @errors << "Логин занят!"
        end
      end
    end
    render "account/registration"
  end
end
