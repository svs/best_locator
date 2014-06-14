BestLocator::Application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  namespace 'api' do
    namespace 'v1' do
      resources :routes
      resources :location_reports
      resources :bus_stops
      resources :trips do
        member do
          put 'stop'
          put 'start'
        end
        collection do
          get 'live'
        end
      end
      resources :users
      resources :sessions, only: [:create, :destroy]
      resources :browse do
        collection do
          get 'map_squares'
          get 'areas'
          get 'bus_stops'
          get 'route'
        end
      end
    end
  end


  resources :trips
  resources :routes
  resources :users do
    resources :trips
  end

  match '/profile', :to => 'users#profile', :via => "get"

  root "home#index"

end
