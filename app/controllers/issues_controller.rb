class IssuesController < ApplicationController
  def index
    @issues = Issue.page(params[:page]).per(10)
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def new
    @issue = Issue.new
    @client_id = current_client.id
  end

  def create
    @issue = Issue.new(params[:issue])
    if @issue.save
      flash[:success] = "Issue successfully created!"
      redirect_to project_issues_url(params[:project_id])
    else
      render :new
    end
  end

  def edit
    @issue = Issue.find(params[:id])
    @client_id = current_client.id
  end

  def update
    @issue = Issue.find(params[:id])
    if @issue.update_attributes(params[:issue])
      flash[:success] = "Issue successfully updated!"
      redirect_to project_issues_url(params[:project_id])
    else
      render :edit
    end
  end
end
