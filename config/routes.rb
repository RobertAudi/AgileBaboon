AgileBaboon::Application.routes.draw do
  # Kong routes
  constraints :subdomain => 'kong' do
    scope :module => 'kong', :as => 'kong' do
      # Clients
      resources :clients

      # Users
      resources :users

      # Sessions
      resources :sessions
      get "/login" => "sessions#new", :as => "login"
      delete "/logout" => "sessions#destroy", :as => "logout"

      # Root path
      root :to => "clients#index"
    end
  end

  get "/dashboard" => "dashboard#index", :as => "dashboard"
end
