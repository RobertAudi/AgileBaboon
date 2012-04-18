AgileBaboon::Application.routes.draw do
  # Kong routes
  constraints :subdomain => "kong" do
    scope :module => "kong", :as => "kong" do
      # Clients
      resources :clients
    end
  end
end
