class MakeClientIdRequiredOnUsersTable < ActiveRecord::Migration
  def up
    change_column :users, :client_id, :integer, null: false
  end

  def down
    change_column :users, :client_id, :integer
  end
end
