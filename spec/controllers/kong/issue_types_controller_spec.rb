require 'spec_helper'

describe Kong::IssueTypesController do
  render_views

  before(:each) do
    @request.host = "kong.lvh.me"
  end

  it "should inherit from Kong::BaseController" do
    Kong::IssueTypesController.superclass.should == Kong::BaseController
  end

  describe "GET 'index'" do
    before(:each) do
      42.times do
        create(:issue_type)
      end
    end

    it "should restrict access to signed in users" do
      get :index
      response.should redirect_to kong_login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:kong_user))
        get :index
      end

      it_behaves_like "a Kong controller"

      it "returns http success" do
        response.should be_success
      end

      it "should fetch all issue types from page 1" do
        assigns(:issue_types).should == IssueType.page(1).per(20)
      end

      it "should have a table row for each issue type" do
        IssueType.page(1).per(20).each do |issue_type|
          response.body.should have_selector('tr > td', text: issue_type.label)
        end
      end

      it "should paginate the issue types table" do
        response.body.should have_selector('.pagination')
        response.body.should have_selector('.pagination .page')
      end
    end
  end

  describe "GET 'new'" do
    it "should restrict access to signed in users" do
      get :new
      response.should redirect_to kong_login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:kong_user))
        get :new
      end

      it_behaves_like "a Kong controller"

      it "returns http success" do
        response.should be_success
      end

      it "should create a new issue type instance and it in and instance variable" do
        assigns(:issue_type).should be_an_instance_of IssueType
      end
    end
  end

  describe "POST 'create'" do
    let(:attr) { { label: "" } }

    it "should restrict access to signed in users" do
      post :create, issue_type: attr
      response.should redirect_to kong_login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:kong_user))
      end

      it "returns http success" do
        post :create, issue_type: attr
        response.should be_success
      end

      it "should create a new user instance and put it in an instance variable" do
        post :create, issue_type: attr
        issue_type = assigns(:issue_type)
        issue_type.should be_an_instance_of IssueType
        issue_type.label.should == attr[:label]
      end

      context "with invalid attributes" do
        context "templates" do
          before(:each) do
            post :create, issue_type: attr
          end

          it_behaves_like "a Kong controller"

          it "should render the 'new' template" do
            response.should render_template('new')
          end
        end

        it "should not create a new user" do
          expect {
            post :create, issue_type: attr
          }.to_not change(IssueType, :count)
        end
      end

      context "with valid attributes" do
        it "should display a confirmation message (flash)" do
          post :create, issue_type: attributes_for(:issue_type)
          flash[:success].should =~ /Issue type successfully created/
        end

        it "should redirect to the issue types index page" do
          post :create, issue_type: attributes_for(:issue_type)
          response.should redirect_to(kong_issue_types_url)
        end

        it "should create a new issue type" do
          expect {
            post :create, issue_type: attributes_for(:issue_type)
          }.to change(IssueType, :count).by(1)
        end
      end
    end
  end

  describe "GET 'edit'" do
    let(:issue_type) { create(:issue_type) }

    it "should restrict access to un-authenticated users" do
      get :edit, id: issue_type
      response.should redirect_to kong_login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:kong_user))
      end

      it "returns http success" do
        get :edit, id: issue_type
        response.should be_success
      end

      it "should fetch the current issue type" do
        get :edit, id: issue_type
        assigns(:issue_type).should == issue_type
      end
    end
  end

  describe "PUT 'update'" do
    let(:issue_type) { create(:issue_type) }

    it "should restrict access to authenticated users" do
      put :update, id: issue_type, issue_type: attributes_for(:issue_type)
      response.should redirect_to kong_login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:kong_user))
      end

      it "should fetch the correct issue type" do
        put :update, id: issue_type, issue_type: attributes_for(:issue_type)
        assigns(:issue_type).should == issue_type
      end

      context "with invalid attributes" do
        context "templates" do
          before(:each) do
            put :update, id: issue_type, issue_type: attributes_for(:issue_type, label: nil)
          end

          it "should render the 'edit' template" do
            response.should render_template('edit')
          end
        end

        it "returns http success" do
          put :update, id: issue_type, issue_type: attributes_for(:issue_type, label: nil)
          response.should be_success
        end

        it "should not update the issue type label" do
          put :update, id: issue_type, issue_type: attributes_for(:issue_type, label: nil)
          issue_type.reload
          issue_type.label.should_not be_nil
        end
      end

      context "with valid attributes" do
        it "should change the issue type label" do
          put :update, id: issue_type, issue_type: attributes_for(:issue_type, label: "TODO")
          issue_type.reload
          issue_type.label.should == "TODO"
        end

        it "should show a confirmation message (flash)" do
          put :update, id: issue_type, issue_type: attributes_for(:issue_type)
          flash[:success].should =~ /Issue type successfully updated/
        end

        it "should redirect the user to the issue types index page" do
          put :update, id: issue_type, issue_type: attributes_for(:issue_type)
          response.should redirect_to(kong_issue_types_url)
        end
      end
    end
  end

end
