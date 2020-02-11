Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        collection do
          post :registration
          post :login
          get :profile
        end
      end
    end
  end
end
