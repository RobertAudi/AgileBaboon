class Kong::UsersController < Kong::BaseController
  def index
    @users = Kong::User.page(1).per(10)
  end

  def new
    @user = Kong::User.new
  end

  def create
    @user = Kong::User.new(params[:kong_user])
    if @user.save
      flash[:success] = "User created successfully"
      redirect_to kong_users_url
    else
      render :new
    end
  end

  def edit
    @user = Kong::User.find(params[:id])
  end

  def update
    @user = Kong::User.find(params[:id])
    if @user.update_attributes(params[:kong_user])
      flash[:success] = "User updated successfully"
      redirect_to kong_users_url
    else
      render :edit
    end
  end

  def destroy
    user = Kong::User.find(params[:id])
    if user.destroy
      flash[:success] = "User deleted successfully"
      redirect_to kong_users_url
    else
      flash[:error] = "Something went wrong. User not delete!"
      redirect_to kong_users_url
    end
  end
end
