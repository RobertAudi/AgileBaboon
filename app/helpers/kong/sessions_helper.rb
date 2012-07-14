module Kong::SessionsHelper
  def log_in(user)
    session[:kong_user_id] = user.id
    current_kong_user = user
  end

  def logged_in?
    !current_kong_user.nil?
  end

  def current_kong_user=(user)
    @current_kong_user = user
  end

  def current_kong_user
    @current_kong_user ||= Kong::User.find(session[:kong_user_id]) if session[:kong_user_id]
  end

  def log_out
    current_kong_user = nil
    session.delete(:kong_user_id)
  end

  def authorize
    unless logged_in?
      store_location
      flash[:notice] = "Acces to this section of the site is restricted"
      redirect_to kong_login_url
    end
  end

  def redirect_back_or_to(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end
