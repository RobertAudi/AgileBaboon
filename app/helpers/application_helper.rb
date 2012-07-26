module ApplicationHelper
  def current_client
    client_account_name = request.subdomain
    Apartment::Database.switch
    client = Client.find_by_account_name(client_account_name)
    Apartment::Database.switch(client_account_name)
    client
  end
end
