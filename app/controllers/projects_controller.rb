class ProjectsController < ApplicationController
  before_filter :admin_required, except: [:show]

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      flash[:success] = "Project successfully created!"
      redirect_to dashboard_url
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated successfully!"
      redirect_to dashboard_url
    else
      render :edit
    end
  end
end
