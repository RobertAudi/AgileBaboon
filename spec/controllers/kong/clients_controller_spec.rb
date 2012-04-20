require 'spec_helper'

describe Kong::ClientsController do
  render_views

  before(:each) do
    @request.host = "kong.lhv.me"
  end

  shared_examples_for "a Kong controller" do
    context "the layout" do
      it "should render the kong layout" do
        response.should render_template('layouts/kong')
      end
    end
  end

  it "should inherit from Kong::BaseController" do
    Kong::ClientsController.superclass.should == Kong::BaseController
  end

  describe "GET 'index'" do
    before(:each) do
      42.times do
        create(:client)
      end

      get :index
    end

    it_behaves_like "a Kong controller"

    it "returns http success" do
      response.should be_success
    end

    it "should fetch all clients from page 1" do
      assigns(:clients).should == Client.page(1).per(10)
    end

    it "should have a table row for each client" do
      Client.page(1).per(10).each do |client|
        response.body.should have_selector('tr > td', :text => client.account_name)
        response.body.should have_selector('tr > td', :text => client.contact_name)
        response.body.should have_selector('tr > td', :text => client.contact_email)
      end
    end

    it "should paginate the clients table" do
      response.body.should have_selector('.pagination')
      response.body.should have_selector('.pagination .page')
    end
  end

  describe "GET 'show'" do
    let (:client) { create(:client) }

    before(:each) do
      get :show, :id => client.id
    end

    it_behaves_like "a Kong controller"

    it "returns http success" do
      response.should be_success
    end

    it "should fetch the correct client" do
      assigns(:client).should == client
    end
  end

  describe "GET 'new'" do
    before(:each) do
      get :new
    end

    it "returns http success" do
      response.should be_success
    end

    it "should create a new client instance and put it in an instance variable" do
      assigns(:client).should be_an_instance_of Client
    end
  end

  describe "POST 'create'" do
    let (:attr) do
      {
        :account_name  => "",
        :contact_name  => "",
        :contact_email => ""
      }
    end

    it "returns http success" do
      post :create, :client => attr
      response.should be_success
    end

    it "should create a new client instace and put it in an instance variable" do
      post :create, :client => attr
      client = assigns(:client)
      client.should be_an_instance_of Client
      client.contact_name.should  == attr[:contact_name]
      client.account_name.should  == attr[:account_name]
      client.contact_email.should == attr[:contact_email]
    end

    context "with invalid attributes" do
      context "templates" do
        before(:each) do
          post :create, :client => attr
        end

        it_behaves_like "a Kong controller"

        it "should render the 'new' page" do
          response.should render_template("new")
        end
      end

      it "should not create a new client" do
        expect {
          post :create, :client => attr
        }.to_not change(Client, :count)
      end
    end

    context "with valid attributes" do
      it "should display a confirmation message (flash)" do
        post :create, :client => attributes_for(:client)
        flash[:success].should =~ /Client successfully created/
      end

      it "should redirect the user to the index page" do
        post :create, :client => attributes_for(:client)
        response.should redirect_to(kong_clients_url)
      end

      it "should create a new client" do
        expect {
          post :create, :client => attributes_for(:client)
        }.to change(Client, :count).by(1)
      end
    end
  end

  describe "GET 'edit'" do
    let (:client) { create(:client) }

    before(:each) do
      get :edit, :id => client
    end

    it "returns http success" do
      response.should be_success
    end

    it "should fetch the correct client" do
      assigns(:client).should == client
    end
  end

  describe "PUT 'update'" do
    let(:client) { create(:client) }

    it "should fetch the correct client" do
      put :update, :id => client, :client => attributes_for(:client)
      assigns(:client).should == client
    end

    it "should not change the account name" do
      put :update, :id => client,
                   :client => attributes_for(:client, :account_name => "awesome")
      client.reload
      client.account_name.should_not == "awesome"
      flash[:error].should =~ /The account name cannot be changed/
      response.should render_template('edit')
    end

    context "with invalid attributes" do
      context "templates" do
        before(:each) do
          put :update, :id => client,
                       :client => attributes_for(:client, :contact_name => nil)
        end

        it_behaves_like "a Kong controller"

        it "renders the 'edit' template" do
          response.should render_template('edit')
        end
      end

      it "returns http success" do
        put :update, :id => client,
                     :client => attributes_for(:client, :contact_name => nil)
        response.should be_success
      end

      it "should not update the client attributes" do
        put :update, :id => client,
                     :client => attributes_for(:client, :contact_name  => "Captain Awesome",
                                                        :contact_email => nil)
        client.reload
        client.contact_name.should_not == "Captain Awesome"
        client.contact_email.should_not be_nil
      end
    end

    context "with valid attributes" do
      it "should change the contact's attributes" do
        put :update, :id => client,
                     :client => attributes_for(:client, :account_name => client.account_name,
                                                        :contact_name  => "Captain Awesome",
                                                        :contact_email => "awesome@example.com")
        client.reload
        client.contact_name.should == "Captain Awesome"
        client.contact_email.should == "awesome@example.com"
      end

      it "should redirect the user to the clients index page" do
        put :update, :id => client, :client => attributes_for(:client, :account_name => client.account_name)
        response.should redirect_to kong_clients_url
      end

      it "should display a confirmation message" do
        put :update, :id => client, :client => attributes_for(:client, :account_name => client.account_name)
        flash[:success].should =~ /Client updated successfully/
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:client) { create(:client) }

    it "should delete a client" do
      expect {
        delete :destroy, :id => client
      }.to change(Client, :count).by(-1)
    end

    it "should redirect the user to the clients page" do
      delete :destroy, :id => client
      response.should redirect_to(kong_clients_url)
    end

    it "should show the user a nice confirmation message" do
      delete :destroy, :id => client
      flash[:success].should =~ /Client deleted successfully/
    end
  end
end
