Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'account/login', action: :login, controller: 'account'
  post 'account/login', action: :login, controller: 'account'
  get 'account/registration', action: :registration, controller: 'account'
  post 'account/registration', action: :registration, controller: 'account'
  get 'account/logout', action: :logout, controller: 'account'
  get '/', action: :index, controller: :products
  post '/api/get_token', action: :get_token, controller: :account
  get '/api/get_external_token', action: :get_external_token, controller: :account

  resources :products
end
