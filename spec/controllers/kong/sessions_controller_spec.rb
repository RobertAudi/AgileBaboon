require 'spec_helper'

describe Kong::SessionsController do

  before(:each) do
    @request.host = "kong.lvh.me"
  end

  it "should inherit from Kong::BaseController" do
    Kong::SessionsController.superclass.should == Kong::BaseController
  end

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do
    context "failed attempt to login" do
      let(:attr) { { :login => "", :password => "" } }

      it "should render the 'new' template" do
        post :create, :login => attr[:login], :password => attr[:password]
        response.should render_template('new')
      end

      it "should show an error message" do
        post :create, :login => attr[:login], :password => attr[:password]
        flash[:error].should =~ /Login\/Password combination incorrect/
      end
    end

    context "successful attempt to login" do
      let(:attr) { {:login => "user", :password => "password" } }

      before(:each) do
        @user = create(:kong_user, :username => "user",
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
        response.should redirect_to kong_root_url
      end
    end
  end

  describe "DELETE 'destroy'" do
    let(:attr) { {:login => "user", :password => "password" } }

    before(:each) do
      @user = create(:kong_user, :username => "user",
                            :password => "password",
                            :password_confirmation => "password")
      controller.log_in @user
    end

    it "should log the user out" do
      delete :destroy, :id => @user.id
      session[:kong_user_id].should be_nil
    end

    it "should display a confirmation message" do
      delete :destroy, :id => @user.id
      flash[:success].should =~ /Successfully logged out/
    end

    it "should redirect the user to the login page" do
      delete :destroy, :id => @user.id
      response.should redirect_to kong_login_url
    end
  end
end
