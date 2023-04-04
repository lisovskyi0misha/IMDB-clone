Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :movies do
    resources :ratings, only: %i[create update destroy]
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
