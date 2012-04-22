AgileBaboon::Application.routes.draw do
  # Kong routes
  constraints :subdomain => 'kong' do
    scope :module => 'kong', :as => 'kong' do
      # Clients
      resources :clients

      # Users
      resources :users

      # Root path
      root :to => "clients#index"
    end
  end
end
