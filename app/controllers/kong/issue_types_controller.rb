class Kong::IssueTypesController < Kong::BaseController
  def index
    @issue_types = IssueType.page(params[:page]).per(20)
  end

  def new
    @issue_type = IssueType.new
  end

  def create
    @issue_type = IssueType.new(params[:issue_type])
    if @issue_type.save
      flash[:success] = "Issue type successfully created!"
      redirect_to kong_issue_types_url
    else
      render :new
    end
  end

  def edit
    @issue_type = IssueType.find(params[:id])
  end

  def update
    @issue_type = IssueType.find(params[:id])
    if @issue_type.update_attributes(params[:issue_type])
      flash[:success] = "Issue type successfully updated!"
      redirect_to kong_issue_types_url
    else
      render :edit
    end
  end
end
