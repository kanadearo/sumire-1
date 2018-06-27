Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users,
  path: '',
  path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile'},
  controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  root to: 'homes#index'
  resources :users do
    member do
      get :followings
      get :followers
      get :like_mymaps
      get :self_mymaps
      get :profile
      get :all_mymap_spots
    end
  end
  resources :places do
    collection do
      get :list
      get :place_map
    end

    member do
      get :plus_place
      post :plus_place_create
    end
  end
  resources :mymaps, except: [:index] do
    collection do
      get :search
      get :result
    end
  end
  resources :mymap_searchs, only: [:index] do
    collection do
      get :recomend_mymaps
      get :following_mymaps
    end
  end
  resources :user_searchs, only: [:index] do
    collection do
      get :recomend_users
      get :following_users
      get :facebook_users
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :user_mymaps, only: [:create, :destroy]

end
