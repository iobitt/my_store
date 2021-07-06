Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'account/login', action: :login, controller: 'account'
  post 'account/login', action: :login, controller: 'account'
  get 'account/registration', action: :registration, controller: 'account'
  post 'account/registration', action: :registration, controller: 'account'
end
