require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    begin
      client = create(:client)
    rescue
      client = Client.create!(attributes_for(:client))
    end

    @request.host = "#{client.account_name}.lvh.me"
  end

  describe "GET 'index'" do
    it "should restrict access to signed in users" do
      get :index
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:user))
        get :index
      end

      it "returns http success" do
        response.should be_success
      end

      it "should fetch all users from page 1" do
        assigns(:users).should == User.page(1).per(10)
      end

      it "should have a table row for each user" do
        User.page(1).per(10).each do |user|
          response.body.should have_selector('tr > td', text: user.username)
          response.body.should have_selector('tr > td', text: user.email)
        end
      end

      it "should paginate the users table" do
        42.times do
          create(:user)
        end

        get :index

        response.body.should have_selector('.pagination')
        response.body.should have_selector('.pagination .page')
      end
    end
  end

  describe "GET 'new'" do
    it "should restrict access to signed in users" do
      get :new
      response.should redirect_to login_url
    end

    context "for authenticated users" do

      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        get :new
        response.should redirect_to dashboard_url
      end

      context "for admin users" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
          get :new
        end

        it "returns http success" do
          response.should be_success
        end

        it "should create a new User instance and put it in an instance variable" do
          assigns(:user).should be_an_instance_of User
        end
      end
    end
  end

  describe "POST 'create'" do
    let(:attr) do
      {
        username: "",
        email:    "",
        password: "",
        password_confirmation: "",
        admin: "0",
        client_id: 0
      }
    end

    it "should restrict access to authenticated users" do
      post :create, user: attr
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        post :create, user: attr
        response.should redirect_to dashboard_url
      end

      context "for admin users" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
        end

        it "returns http success" do
          post :create, user: attr
          response.should be_success
        end

        it "should create a new user instance and put it in an instance variable" do
          post :create, user: attr
          user = assigns(:user)
          user.should be_an_instance_of User
          user.username.should == attr[:username]
          user.email.should == attr[:email]
          user.password.should == attr[:password]
          user.password_confirmation.should == attr[:password_confirmation]
        end

        context "with invalid attributes" do
          context "templates" do
            before(:each) do
              post :create, user: attr
            end

            it "should render the 'new' template" do
              response.should render_template('new')
            end
          end

          it "should not create a new user" do
            expect {
              post :create, user: attr
            }.to_not change(User, :count)
          end
        end

        context "with valid attributes" do
          it "should display a confirmation message (flash)" do
            post :create, user: attributes_for(:user)
            flash[:success].should =~ /User created successfully/
          end

          it "should redirect to the users index page" do
            post :create, user: attributes_for(:user)
            response.should redirect_to(users_url)
          end

          it "should create a new user" do
            expect {
              post :create, user: attributes_for(:user)
            }.to change(User, :count).by(1)
          end
        end
      end
    end
  end

  # FIXME: Users should be able to edit their own profile
  describe "GET 'edit'" do
    let(:user) { create(:user) }

    it "should restrict access to authenticated users" do
      get :edit, id: user
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        get :edit, id: user
        response.should redirect_to dashboard_url
      end

      context "for admin users" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
          get :edit, id: user
        end

        it "returns http success" do
          response.should be_success
        end

        it "should render the 'edit' template" do
          response.should render_template 'edit'
        end

        it "should fetch the correct user" do
          assigns(:user).should == user
        end
      end
    end
  end

  describe "PUT 'update'" do
    let(:user) { create(:user) }

    it "should restrict access to authenticated users" do
      put :update, id: user, user: attributes_for(:user)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        put :update, id: user, user: attributes_for(:user)
        response.should redirect_to dashboard_url
      end

      context "for admin users" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
        end

        it "should fetch the correct user" do
          put :update, id: user, user: attributes_for(:user)
          assigns(:user).should == user
        end

        context "with invalid attributes" do
          context "templates" do
            before(:each) do
              put :update, id: user, user: attributes_for(:user, username: nil)
            end

            it "should render the 'edit' template" do
              response.should render_template('edit')
            end
          end

          it "returns http success" do
            put :update, id: user, user: attributes_for(:user, username: nil)
            response.should be_success
          end

          it "should not update the user attributes" do
            put :update, id: user, user: attributes_for(:user, username: "user",
                                                        email: nil)

            user.reload
            user.username.should_not == "user"
            user.email.should_not be_nil
          end
        end

        context "with valid attributes" do
          it "should change the user's attributes" do
            put :update, id: user, user: attributes_for(:user, username: "user",
                                                        email: "user@example.com")

            user.reload
            user.username.should == "user"
            user.email.should == "user@example.com"
          end

          it "should show a confirmation message" do
            put :update, id: user, user: attributes_for(:user)
            flash[:success].should =~ /User updated successfully/
          end

          it "should redirect the user to the users index page" do
            put :update, id: user, user: attributes_for(:user)
            response.should redirect_to(users_url)
          end
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:user) { create(:user) }

    it "should restrict access to authenticated users" do
      delete :destroy, id: user
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-superadmins" do
        controller.log_in(create(:user))
        delete :destroy, id: user
        response.should redirect_to dashboard_url

        controller.log_out

        admin = create(:admin)
        admin.add_role :admin
        controller.log_in(admin)
        delete :destroy, id: user
        response.should redirect_to dashboard_url
      end

      context "for superadmins" do
        before(:each) do
          controller.log_in(create(:superadmin))
          controller.current_user.add_role :superadmin
        end

        it "should delete a user" do
          expect {
            delete :destroy, id: user
          }.to change(User, :count).by(-1)
        end

        it "should redirect the user to the users index page" do
          delete :destroy, id: user
          response.should redirect_to(users_url)
        end

        it "should show the user a nice confirmation message" do
          delete :destroy, id: user
          flash[:success].should =~ /User deleted successfully/
        end
      end
    end
  end
end
