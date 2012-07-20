class RenameAdminColumnToSuperAdmin < ActiveRecord::Migration
  def up
    rename_column :users, :admin, :superadmin
  end

  def down
    rename_column :users, :superadmin, :admin
  end
end
