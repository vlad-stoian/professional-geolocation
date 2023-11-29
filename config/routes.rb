Rails.application.routes.draw do
  resources :address_geolocations, only: [:index, :new, :create, :show, :destroy]

  # jsonapi_resources :address_geolocations
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "address_geolocations#index"
end
