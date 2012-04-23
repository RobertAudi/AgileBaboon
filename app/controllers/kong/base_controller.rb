class Kong::BaseController < ActionController::Base
  protect_from_forgery

  layout 'kong'

  helper_method :current_user

  def current_user
    @current_user ||= Kong::User.find(session[:kong_user_id]) if session[:kong_user_id]
  end
end
