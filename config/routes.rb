Rails.application.routes.draw do
  devise_for :users,
  path: '',
  path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile'},
  controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  root to: 'homes#index'
  resources :users do
    member do
      get :friends
      get :friends_result
      get :followings
      get :followers
      get :profile
    end
  end
  resources :places do
    collection do
      get :list
    end
  end
  resources :mymaps, except: [:index] do
    collection do
      get :search
      get :result
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :user_mymaps, only: [:create, :destroy]
end
