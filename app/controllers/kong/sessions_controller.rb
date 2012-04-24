class Kong::SessionsController < Kong::BaseController
  skip_before_filter :authorize

  def new
  end

  def create
    user = Kong::User.find_by_username(params[:login]) || Kong::User.find_by_email(params[:login])
    if user && user.authenticate(params[:password])
      session[:kong_user_id] = user.id
      flash[:success] = "Logged in successfully"
      redirect_to kong_root_url
    else
      flash[:error] = "Login/Password combination incorrect"
      render 'new'
    end
  end

  def destroy
    session[:kong_user_id] = nil
    redirect_to kong_login_url
  end
end
