class CreateIssueTypes < ActiveRecord::Migration
  def change
    create_table :issue_types do |t|
      t.string :label, :null => false

      t.timestamps
    end
  end
end
