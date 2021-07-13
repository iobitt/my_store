Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'account/login', action: :login, controller: 'account'
  post 'account/login', action: :login, controller: 'account'
  get 'account/registration', action: :registration, controller: 'account'
  post 'account/registration', action: :registration, controller: 'account'
  get 'account/logout', action: :logout, controller: 'account'
  get 'account/add_external_token', action: :add_external_token, controller: 'account'
  post 'account/add_external_token', action: :add_external_token, controller: 'account'
  get '/', action: :index, controller: :products

  resources :products
end
