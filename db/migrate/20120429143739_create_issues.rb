class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title, :null => false
      t.string :description, :null => false
      t.integer :issue_type_id, :null => false
      t.integer :user_id, :null => false
      t.integer :client_id, :null => false
      t.datetime :closed_at

      t.timestamps
    end
  end
end
