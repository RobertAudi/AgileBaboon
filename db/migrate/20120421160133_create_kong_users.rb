class CreateKongUsers < ActiveRecord::Migration
  def change
    create_table :kong_users do |t|
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :password_hash, :null => false
      t.string :password_salt, :null => false

      t.timestamps
    end
  end
end
