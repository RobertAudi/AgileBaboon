AgileBaboon::Application.routes.draw do
  # Kong routes
  constraints subdomain: 'kong' do
    scope module: 'kong', as: 'kong' do
      # Issue Types
      resources :issue_types, except: [:show]

      # Clients
      resources :clients

      # Users
      resources :users

      # Sessions
      resources :sessions
      get "/login" => "sessions#new", as: "login"
      delete "/logout" => "sessions#destroy", as: "logout"

      # Root path
      root to: "clients#index"
    end
  end

  # Sessions
  resources :sessions
  get "/login" => "sessions#new", as: "login"
  delete "/logout" => "sessions#destroy", as: "logout"

  # Users
  resources :users, except: [:show]

  # Projects
  resources :projects, except: [:index, :destroy] do
    # Projects' issues
    resources :issues

    # Projects' users
    resources :users, except: [:show]
  end

  get "/dashboard" => "dashboard#index", as: "dashboard"

  root to: "dashboard#index"
end
