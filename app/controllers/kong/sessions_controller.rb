class Kong::SessionsController < Kong::BaseController
  layout 'kong_login'

  skip_before_filter :authorize

  def new
  end

  def create
    user = Kong::User.find_by_username(params[:login]) || Kong::User.find_by_email(params[:login])
    if user && user.authenticate(params[:password])
      log_in user
      flash[:success] = "Logged in successfully"
      redirect_to kong_root_url
    else
      flash[:error] = "Login/Password combination incorrect"
      render 'new'
    end
  end

  def destroy
    if log_out
      flash[:success] = "Successfully logged out"
      redirect_to kong_login_url
    else
      flash[:error] = "Something went wrong, not logged out"
      redirect_to kong_root_url
    end
  end
end
