require 'spec_helper'

describe IssuesController do
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
      get :index, project_id: create(:project)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:user))
        get :index, project_id: create(:project)
      end

      it "returns http success" do
        response.should be_success
      end

      it "should fetch all issues from page 1" do
        assigns(:issues).should == Issue.page(1).per(10)
      end

      it "should have a table row for each issue" do
        Issue.page(1).per(10).each do |issue|
          response.body.should have_selector('tr > td', text: issue.title)
          response.body.should have_selector('tr > td', text: issue.issue_type.label)
          response.body.should have_selector('tr > td', text: issue.user.username)
        end
      end

      it "should paginate the issues table" do
        issue = create(:issue)
        42.times do
          create(:issue)
        end

        get :index, project_id: issue.project_id

        response.body.should have_selector('.pagination')
        response.body.should have_selector('.pagination .page')
      end
    end
  end

  describe "GET 'show'" do
    let(:issue) { create(:issue) }

    it "should restrict access to signed in users" do
      get :show, project_id: issue.project_id, id: issue
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:user))
        get :show, project_id: issue.project_id, id: issue
      end

      it "returns http success" do
        response.should be_success
      end

      it "should fetch the correct issue" do
        assigns(:issue).should == issue
      end
    end
  end

  describe "GET 'new'" do

    it "should restrict access to signed in users" do
      get :new, project_id: create(:project)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:user))
        get :new, project_id: create(:project)
      end

      it "returns http success" do
        response.should be_success
      end

      it "should create a new issue instance and put it in an instance variable" do
        assigns(:issue).should be_an_instance_of Issue
      end
    end
  end

  describe "POST 'create'" do
    let (:attr) do
      {
        title: "",
        description: "",
        issue_type_id: 0,
        user_id: 0,
        project_id: 1
      }
    end

    it "should restrict access to signed in users" do
      post :create, project_id: attr[:project_id], issue: attr
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:user))
      end

      it "returns http success" do
        post :create, project_id: attr[:project_id], issue: attr
        response.should be_success
      end

      it "should create a new issue instance and put it in an instance variable" do
        post :create, project_id: attr[:project_id], issue: attr
        issue = assigns(:issue)
        issue.should be_an_instance_of Issue
        issue.title.should == attr[:title]
        issue.description.should == attr[:description]
        issue.issue_type_id.should == attr[:issue_type_id]
        issue.user_id.should == attr[:user_id]
      end

      context "with invalid attributes" do
        context "templates" do
          before(:each) do
            post :create, project_id: attr[:project_id], issue: attr
          end

          it "should render the 'new' page" do
            response.should render_template('new')
          end
        end

        it "should not create a new issue" do
          expect {
            post :create, project_id: attr[:project_id], issue: attr
          }.to_not change(Issue, :count)
        end
      end

      context "with valid attributes" do
        let(:attr) { build(:issue).attributes.symbolize_keys.delete_if { |k, v| v.nil? } }

        it "should create a new issue" do
          expect {
            post :create, project_id: attr[:project_id], issue: attr
          }.to change(Issue, :count).by(1)
        end

        it "should redirect the user to the issues index page" do
          post :create, project_id: attr[:project_id], issue: attr
          response.should redirect_to(project_issues_url(attr[:project_id]))
        end

        it "should display a confirmation message" do
          post :create, project_id: attr[:project_id], issue: attr
          flash[:success].should =~ /Issue successfully created/
        end
      end
    end
  end

  describe "GET 'edit'" do
    let(:issue) { create(:issue) }

    it "should restrict access to signed in users" do
      get :edit, project_id: issue.project_id, id: issue
      response.should redirect_to login_url
    end

    context "for authenticated user" do
      before(:each) do
        controller.log_in(create(:user))
        get :edit, project_id: issue.project_id, id: issue
      end

      it "returns http success" do
        response.should be_success
      end

      it "should fetch the correct issue" do
        assigns(:issue).should == issue
      end
    end
  end

  describe "PUT 'update'" do
    let(:issue) { create(:issue) }

    it "should restrict access to signed in users" do
      put :update, project_id: issue.project_id, id: issue, issue: attributes_for(:issue)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:user))
      end

      it "should fetch the correct issue" do
        put :update, project_id: issue.project_id, id: issue, issue: attributes_for(:issue)
        assigns(:issue).should == issue
      end

      context "with invalid attributes" do
        let(:attr) { { title: nil } }

        context "templates" do
          before(:each) do
            put :update, project_id: issue.project_id, id: issue, issue: attr
          end

          it "should render the 'edit' template" do
            response.should render_template('edit')
          end
        end

        it "returns http success" do
          put :update, project_id: issue.project_id, id: issue, issue: attr
          response.should be_success
        end

        it "should not update the issue" do
          put :update, project_id: issue.project_id, id: issue, issue: attr
          issue.reload
          issue.title.should_not == "This is issue #42"
          issue.description.should_not be_nil
        end
      end

      context "with valid attributes" do
        let(:attr) { build(:issue, title: "This is issue #42").attributes.symbolize_keys.delete_if { |k, v| v.nil? || k == :client_id } }

        it "should change the issue's attributes" do
          put :update, project_id: issue.project_id, id: issue, issue: attr
          issue.reload
          issue.title.should == "This is issue #42"
        end

        it "should redirect the user to the issue index page" do
          put :update, project_id: issue.project_id, id: issue, issue: attr
          response.should redirect_to(project_issues_url(project_id: issue.project_id))
        end

        it "should display a confirmation message" do
          put :update, project_id: issue.project_id, id: issue, issue: attr
          flash[:success].should =~ /Issue successfully updated/
        end
      end
    end
  end
end
