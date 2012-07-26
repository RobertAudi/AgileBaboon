class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(10)
  end

  def new
    @user = User.new

    # FIXME: Change the line below for something better
    @client_id = Client.find_by_account_name(request.subdomain).id
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
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "User updated successfully"
      redirect_to users_url
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
