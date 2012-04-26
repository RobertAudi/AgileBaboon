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

  resources :sessions
  get "/login" => "sessions#new", :as => "login"
  delete "/logout" => "sessions#destroy", :as => "logout"


  get "/dashboard" => "dashboard#index", :as => "dashboard"

  root :to => "sessions#new"
end
