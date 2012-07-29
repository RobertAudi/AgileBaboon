class CreateUsersProjectsRelationships < ActiveRecord::Migration
  def change
    create_table :users_projects do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
    end
  end
end
