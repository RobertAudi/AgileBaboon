require 'spec_helper'

describe SessionsController do

  let(:client) { create(:client, :account_name => "acme") }

  before(:each) do
    @request.host = "#{client.account_name}.lvh.me"
  end

  describe "GET 'new'" do
    it "should redirect the user to the 404 page for invalid clients" do
      @request.host = "foo.lvh.me"
      get :new
      response.should redirect_to "/404.html"
    end

    it "should return http success for valid clients" do
      get :new
      response.should be_success
    end

    it "should set the current tenant to the current clinet" do
      get :new
      ActsAsTenant.current_tenant.account_name.should == "acme"
    end
  end

  describe "POST 'create'" do
    context "failed attempt to login" do
      let(:attr) { { :login => "", :password => "" } }

      it "should render the new template" do
        post :create, :login => attr[:login], :password => attr[:password]
        response.should render_template("new")
      end

      it "should show an error message" do
        post :create, :login => attr[:login], :password => attr[:password]
        flash[:error].should =~ /Login\/Password combination incorrect/
      end
    end

    context "successful attempt to login" do
      let(:attr) { {:login => "user", :password => "password" } }

      before(:each) do
        @user = create(:user, :username => "user",
                      :password => "password",
                      :password_confirmation => "password")
      end

      it "should sign the user in" do
        post :create, :login => attr[:login], :password => attr[:password]
        controller.current_user.should == @user
      end

      it "should show the user a nice confirmation message" do
        post :create, :login => attr[:login], :password => attr[:password]
        flash[:success].should =~ /Logged in successfully/
      end

      it "should redirect the user to the root path" do
        post :create, :login => attr[:login], :password => attr[:password]
        response.should redirect_to dashboard_url
      end
    end
  end

  describe "DELETE 'destroy'" do
    let(:attr) { {:login => "user", :password => "password" } }

    before(:each) do
      @user = create(:user, :username => "user",
                            :password => "password",
                            :password_confirmation => "password")
      controller.log_in @user
    end

    it "should log the user out" do
      delete :destroy, :id => @user.id
      session[:user_id].should be_nil
    end

    it "should display a confirmation message" do
      delete :destroy, :id => @user.id
      flash[:success].should =~ /Successfully logged out/
    end

    it "should redirect the user to the login page" do
      delete :destroy, :id => @user.id
      response.should redirect_to login_url
    end
  end
end
