class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper
  include SessionsHelper

  before_filter :authorize
  before_filter :check_subdomain

  private

  def check_subdomain
    redirect_to "/404.html" if request.subdomain.empty?
  end
end
