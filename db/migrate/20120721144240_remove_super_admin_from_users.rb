class RemoveSuperAdminFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :superadmin
  end

  def down
    add_column :users, :superadmin, :boolean, default: false, null: false
  end
end
