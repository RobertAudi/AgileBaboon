class ApplicationController < ActionController::Base
  protect_from_forgery

  set_current_tenant_by_subdomain(:client, :account_name)

  include SessionsHelper

  before_filter :check_subdomain, :authorize

  private

  def check_subdomain
    redirect_to("/404.html") if ActsAsTenant.current_tenant.nil?
  end
end
