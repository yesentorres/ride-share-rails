Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'application#index'

  resources :drivers
  resources :passengers do
    resources :trips, only: [:index, :new]
    # ^Created the following paths:
    # passenger_trips GET    /passengers/:passenger_id/trips(.:format)                                                trips#index

    # new_passenger_trip GET    /passengers/:passenger_id/trips/new(.:format)                                            trips#new
  end

  resources :trips
end
