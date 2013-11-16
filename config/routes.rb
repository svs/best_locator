BestLocator::Application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  namespace 'api' do
    namespace 'v1' do
      resources :trips do
        member do
          put 'stop'
        end
      end
      resources :users
    end
  end

  root "home#index"

end
