require 'spec_helper'

describe ProjectsController do
  render_views

  before(:each) do
    client = create(:client)
    @request.host = "#{client.account_name}.lvh.me"
  end

  describe "GET 'show'" do
    it "should deny access to guest users" do
      get :show, id: create(:project)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      before(:each) do
        controller.log_in(create(:user))
        @project = create(:project)
        get :show, id: @project
      end

      it "returns http success" do
        response.should be_success
      end

      it "should fetch the correct project and put it in an instance variable" do
        assigns(:project).should == @project
      end
    end
  end

  describe "GET 'new'" do
    it "should deny access to guest users" do
      get :new
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        get :new
        response.should redirect_to dashboard_url
      end

      context "for admins" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
          get :new
        end

        it "returns http success" do
          response.should be_success
        end

        it "should create a new Project instance" do
          assigns(:project).should be_an_instance_of Project
        end
      end
    end
  end

  describe "POST 'create'" do
    it "should deny access to guest users" do
      post :create, project: attributes_for(:project)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        post :create, project: attributes_for(:project)
        response.should redirect_to dashboard_url
      end

      context "for admins" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
        end

        it "should create a new Project instance" do
          post :create, project: attributes_for(:project)
          assigns(:project).should be_an_instance_of Project
        end

        context "with invalid attributes" do
          let(:attr) { { name: "", description: "" } }

          it "returns http success" do
            post :create, project: attr
            response.should be_success
          end

          it "should render the 'new' template" do
            post :create, project: attr
            response.should render_template 'new'
          end

          it "should not create a new project" do
            expect {
              post :create, project: attr
            }.to_not change(Project, :count)
          end
        end

        context "with valid attributes" do
          it "should create a new Project" do
            expect {
              post :create, project: attributes_for(:project)
            }.to change(Project, :count).by(1)
          end

          it "should redirect the user to the dashboard" do
            post :create, project: attributes_for(:project)
            response.should redirect_to dashboard_url
          end

          it "should show a confirmation message" do
            post :create, project: attributes_for(:project)
            flash[:success].should =~ /Project successfully created/
          end
        end
      end
    end
  end

  describe "GET 'edit'" do
    it "should deny access to guest users" do
      get :edit, id: create(:project)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        get :edit, id: create(:project)
        response.should redirect_to dashboard_url
      end

      context "for admins" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
          @project = create(:project)
          get :edit, id: @project
        end

        it "returns http success" do
          response.should be_success
        end

        it "should fetch the correct project" do
          assigns(:project).should == @project
        end
      end
    end
  end

  describe "PUT 'update'" do
    it "should deny access to guest users" do
      put :update, id: create(:project), project: attributes_for(:project)
      response.should redirect_to login_url
    end

    context "for authenticated users" do
      it "should deny access to non-admins" do
        controller.log_in(create(:user))
        put :update, id: create(:project), project: attributes_for(:project)
        response.should redirect_to dashboard_url
      end

      context "for admins" do
        before(:each) do
          admin = create(:admin)
          admin.add_role :admin
          controller.log_in(admin)
        end

        it "should fetch the correct Project and put it into an instance variable" do
          project = create(:project)
          put :update, id: project, project: attributes_for(:project)
          assigns(:project).should == project
        end

        context "with invalid attributes" do
          let(:attr) { { name: "", description: "" } }

          it "returns http success" do
            put :update, id: create(:project), project: attr
            response.should be_success
          end

          it "should render the 'edit' template" do
            put :update, id: create(:project), project: attr
            response.should render_template 'edit'
          end

          it "should not update a project" do
            project = create(:project)
            put :update, id: project, project: attr
            Project.find(project.id).name.should_not == attr[:name]
            Project.find(project.id).description.should_not == attr[:description]
          end
        end

        context "with valid attributes" do
          let(:attr) { attributes_for(:project) }

          it "should update the project's attributes" do
            project = create(:project)
            put :update, id: project, project: attr
            Project.find(project.id).name.should == attr[:name]
            Project.find(project.id).description.should == attr[:description]
          end

          it "should redirect the user to the dashboard" do
            put :update, id: create(:project), project: attr
            response.should redirect_to dashboard_url
          end

          it "should display a confirmation message" do
            put :update, id: create(:project), project: attr
            flash[:success].should =~ /Project updated successfully/
          end
        end
      end
    end
  end
end
