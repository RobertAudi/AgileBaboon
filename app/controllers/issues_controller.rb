class IssuesController < ApplicationController
  def index
    @issues = Issue.page(params[:page]).per(10)
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(params[:issue])
    if @issue.save
      flash[:success] = "Issue successfully created!"
      redirect_to issues_url
    else
      render :new
    end
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def update
    @issue = Issue.find(params[:id])
    if @issue.update_attributes(params[:issue])
      flash[:success] = "Issue successfully updated!"
      redirect_to issues_url
    else
      render 'edit'
    end
  end
end
