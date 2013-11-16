BestLocator::Application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  namespace 'api' do
    namespace 'v1' do
      resources :bus_stops
      resources :users
    end
  end

  root "home#index"

end
