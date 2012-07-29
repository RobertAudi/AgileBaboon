class AddProjectIdToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :project_id, :integer, null: false
  end
end
