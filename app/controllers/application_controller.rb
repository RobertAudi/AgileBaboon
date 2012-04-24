class ApplicationController < ActionController::Base
  protect_from_forgery

  set_current_tenant_by_subdomain(:client, :account_name)
end
