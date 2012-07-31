module ProjectsHelper
  # Fetch the n most recently updated
  # projects from the database
  def projects(n = 5)
    @projects ||= Project.order("updated_at").limit(n)
  end
end
