class AccountController < ApplicationController
  layout "account"
  before_action :check_auth, :only => [:get_external_token]

  def login
    @errors = []

    unless request.method == "GET"
      if !params['login'].is_a?(String) || !params['password'].is_a?(String) || params['login'] == "" || params['password'] == ""
        @errors << "Все поля должны быть заполнены!"
      else
        ok, result, errors = Account::LoginService.new(params['login'], params['password']).call
        if ok
          session[:user_id] = result.id
          return redirect_to "/"
        else
          @errors = errors
        end
      end
    end
    render "account/login"
  end

  def logout
    session[:user_id] = nil
    redirect_to "/account/login/"
  end

  def registration
    @errors = []

    unless request.method == "GET"
      if !params['login'].is_a?(String) || !params['password'].is_a?(String) || !params['password2'].is_a?(String)
        @errors << "Все поля должны быть заполнены!"
      else
        ok, result, errors = Account::RegistrationService.new("Manager", params['login'], params['password'], params['password2']).call

        if ok
          session[:user_id] = result.id
          return redirect_to "/"
        else
          @errors = errors
        end
      end
    end
    render "account/registration"
  end

  def get_token
    response = {}
    ok, result, errors = Account::RegistrationService.new("Api").call

    if ok
      response['ok'] = true
      response['token'] = result.token
    else
      response['ok'] = false
      response['errors'] = errors
    end

    render :json =>  response
  end

  def get_external_token
    user = User.find session[:user_id]
    user.external_token = SecureRandom.urlsafe_base64(32, false)
    user.save

    render plain: "Ваш токен: " + user.external_token
  end

end
