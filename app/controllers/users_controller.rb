class UsersController < ApplicationController
  before_filter :admin_required, only: [:new, :create, :edit, :update]
  before_filter :superadmin_required, only: [:destroy]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def new
    @user = User.new
    @client_id = current_client.id
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.add_role :admin if params[:user][:admin] == "1"

      # Set the Projects the user is associated with
      @user.projects = params[:user][:project_ids].delete_if { |id| id.empty? }.map { |id| Project.find(id) }

      flash[:success] = "User created successfully"
      redirect_to users_url
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
      if params[:user][:admin] == "1"
        @user.add_role :admin
      elsif params[:user][:admin] == "0"
        @user.remove_role :admin
      end

      # Set the Projects the user is associated with
      @user.projects = params[:user][:project_ids].delete_if { |id| id.empty? }.map { |id| Project.find(id) }

      flash[:success] = "User updated successfully"
      redirect_to users_url
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.has_role? :superadmin
      flash[:notice] = "You can't delete this user because he is the only superadmin"
    elsif user.destroy
      flash[:success] = "User deleted successfully"
    else
      flash[:error] = "Something went wrong, user not deleted"
    end

    redirect_to users_url
  end
end
