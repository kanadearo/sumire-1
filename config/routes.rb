Rails.application.routes.draw do
  devise_for :users,
  path: '',
  path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile'},
  controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  root to: 'homes#index'
  resources :users
end
