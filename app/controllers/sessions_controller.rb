class SessionsController < ApplicationController
  skip_before_filter :authorize

  layout 'login'

  def new
    if logged_in?
      flash[:notice] = "You are already logged in!"
      redirect_to dashboard_url
    end
  end

  def create
    user = User.find_by_username(params[:login]) || User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      log_in user
      flash[:success] = "Logged in successfully"
      redirect_to dashboard_url
    else
      flash[:error] = "Login/Password combination incorrect"
      render :new
    end
  end

  def destroy
    if log_out
      flash[:success] = "Successfully logged out"
      redirect_to login_url
    else
      flash[:error] = "Something went wrong, not logged out"
      redirect_to dashboard_url
    end
  end
end
