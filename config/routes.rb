Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      get 'forecast', to: 'forecasts#show'
      resources :users, only: [:create]
      post 'sessions', to: 'sessions#create'
    end

    namespace :v1 do
      get 'book-search', to: 'books#search'
    end
  end
end
