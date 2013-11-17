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
    end
  end


  resources :trips
  resources :users do
    resources :trips
  end

  match '/profile', :to => 'users#profile', :via => "get"

  root "home#index"

end
