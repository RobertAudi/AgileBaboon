class Kong::ClientsController < Kong::BaseController
  def index
    @clients = Client.page(params[:page]).per(10)
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      begin
        create_superadmin_user_for(@client)
      rescue
        @client.destroy
        flash[:error] = "Something went wrong, the client was not created."
      else
        flash[:success] = "Client successfully created!"
      end

      redirect_to kong_clients_url
    else
      render :new
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if params[:client][:account_name].present? && params[:client][:account_name] != @client.account_name
      # The account name is immutable
      flash.now[:error] = "The account name cannot be changed"
      render :edit
    elsif @client.update_attributes(params[:client])
      flash[:success] = "Client updated successfully"
      redirect_to kong_clients_url
    else
      render :edit
    end
  end

  def destroy
    client = Client.find(params[:id])
    if client.destroy
      flash[:success] = "Client deleted successfully"
      redirect_to kong_clients_url
    else
      flash[:error] = "Client not deleted for some reason"
      redirect_to kong_clients_url
    end
  end

  private

  # Create an superadmin user for the new client
  def create_superadmin_user_for(client)
    ActsAsTenant.current_tenant = client
    ::User.create!(username: "admin",
                   email: client.contact_email,
                   password: "admin",
                   password_confirmation: "admin")
  end
end
