module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    current_user = user
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def log_out
    current_user = nil
    session.delete(:user_id)
  end

  def authorize
    unless logged_in?
      store_location
      flash[:notice] = "Acces to this section of the site is restricted"
      redirect_to login_url
    end
  end

  def require_superadmin
    unless current_user.superadmin?
      flash[:notice] = "You don't have permission to access this section of the site"
      redirect_to dashboard_url
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
