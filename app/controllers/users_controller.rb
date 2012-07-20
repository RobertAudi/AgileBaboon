class UsersController < ApplicationController
  before_filter :require_superadmin, except: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "User created successfully"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    unless current_user.superadmin? || @user == current_user
      flash[:notice] = "You don't have permission to access this section of the site"
      redirect_to dashboard_url
    end
  end

  def update
    @user = User.find(params[:id])
    if !current_user.superadmin? && @user != current_user
      flash[:notice] = "You don't have permission to access this section of the site"
      redirect_to dashboard_url
    elsif @user.update_attributes(params[:user])
      flash[:success] = "User updated successfully"
      if current_user.superadmin?
        redirect_to users_url
      else
        redirect_to dashboard_url
      end
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:success] = "User deleted successfully"
    else
      flash[:error] = "Something went wrong, user not deleted"
    end

    redirect_to users_url
  end
end
