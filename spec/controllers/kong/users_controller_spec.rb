require 'spec_helper'

describe Kong::UsersController do
  render_views

  before(:each) do
    @request.host = "kong.lvh.me"
  end

  it "should inherit from Kong::BaseController" do
    Kong::UsersController.superclass.should == Kong::BaseController
  end

  describe "GET 'index'" do
    before(:each) do
      42.times do
        create(:user)
      end

      get :index
    end

    it_behaves_like "a Kong controller"

    it "returns http success" do
      response.should be_success
    end

    it "should fetch all users from page 1" do
      assigns(:users).should == Kong::User.page(1).per(10)
    end

    it "should have a table row for each client" do
      Kong::User.page(1).per(10).each do |user|
        response.body.should have_selector('tr > td', :text => user.username)
        response.body.should have_selector('tr > td', :text => user.email)
      end
    end

    it "should paginate the clients table" do
      response.body.should have_selector('.pagination')
      response.body.should have_selector('.pagination .page')
    end
  end

  describe "GET 'new'" do
    before(:each) do
      get :new
    end

    it_behaves_like "a Kong controller"

    it "returns http success" do
      response.should be_success
    end

    it "should create a new User instance and put it in an instace variable" do
      assigns(:user).should be_an_instance_of Kong::User
    end
  end

  describe "POST 'create'" do
    let(:attr) do
      {
        :username => "",
        :email    => "",
        :password => "",
        :password_confirmation => ""
      }
    end

    it "returns http success" do
      post :create, :user => attr
      response.should be_success
    end

    it "should create a new user instance and put it in an instance variable" do
      post :create, :user => attr
      user = assigns(:user)
      user.should be_an_instance_of Kong::User
      user.username.should == attr[:username]
      user.email.should == attr[:email]
      user.password.should == attr[:password]
      user.password_confirmation.should == attr[:password_confirmation]
    end

    context "with invalid attributes" do
      context "templates" do
        before(:each) do
          post :create, :user => attr
        end

        it_behaves_like "a Kong controller"

        it "should render the 'new' template" do
          response.should render_template('new')
        end
      end

      it "should not create a new user" do
        expect {
          post :create, :user => attr
        }.to_not change(Kong::User, :count)
      end
    end

    context "with valid attributes" do
      it "should display a confirmation message (flash)" do
        post :create, :user => attributes_for(:user)
        flash[:success].should =~ /User created successfully/
      end

      it "should redirect to the users index page" do
        post :create, :user => attributes_for(:user)
        response.should redirect_to(kong_users_url)
      end

      it "should create a new user" do
        expect {
          post :create, :user => attributes_for(:user)
        }.to change(Kong::User, :count).by(1)
      end
    end
  end

  describe "GET 'edit'" do
    let(:user) { create(:user) }

    before(:each) do
      get :edit, :id => user
    end

    it "returns http success" do
      response.should be_success
    end

    it "should fetch the correct user" do
      assigns(:user).should == user
    end
  end

  describe "PUT 'update'" do
    let(:user) { create(:user) }

    it "should fetch the correct user" do
      put :update, :id => user, :user => attributes_for(:user)
      assigns(:user).should == user
    end

    context "with invalid attributes" do
      context "templates" do
        before(:each) do
          put :update, :id => user, :user => attributes_for(:user, :username => nil)
        end

        it_behaves_like "a Kong controller"

        it "should render the 'edit' template" do
          response.should render_template('edit')
        end
      end

      it "returns http success" do
        put :update, :id => user, :user => attributes_for(:user, :username => nil)
        response.should be_success
      end

      it "should not update the user attributes" do
        put :update, :id => user, :user => attributes_for(:user, :username => "user",
                                                                 :email => nil)

        user.reload
        user.username.should_not == "user"
        user.email.should_not be_nil
      end
    end

    context "with valid attributes" do
      it "should change the user's attributes" do
        put :update, :id => user, :user => attributes_for(:user, :username => "user",
                                                                 :email => "user@example.com")

        user.reload
        user.username.should == "user"
        user.email.should == "user@example.com"
      end

      it "should show a confirmation message" do
        put :update, :id => user, :user => attributes_for(:user)
        flash[:success].should =~ /User updated successfully/
      end

      it "should redirect the user to the users index page" do
        put :update, :id => user, :user => attributes_for(:user)
        response.should redirect_to(kong_users_url)
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:user) { create(:user) }

    it "should delete a user" do
      expect {
        delete :destroy, :id => user
      }.to change(Kong::User, :count).by(-1)
    end

    it "should redirect the user to the users index page" do
      delete :destroy, :id => user
      response.should redirect_to(kong_users_url)
    end

    it "should show the user a nice confirmation message" do
      delete :destroy, :id => user
      flash[:success].should =~ /User deleted successfully/
    end
  end
end
