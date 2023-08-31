Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        collection do
          get 'search', to: 'markets#search'
        end
        member do
          get 'nearest_atms', to: 'markets#nearest_atms'
        end
        resources :vendors, only: [:index]
      end
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only: [:create]
      delete '/market_vendors', to: 'market_vendors#destroy'
    end
  end
end
