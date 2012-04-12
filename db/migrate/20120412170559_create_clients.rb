class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :account_name, :null => false
      t.string :contact_name, :null => false
      t.string :contact_email, :null => false

      t.timestamps
    end
  end
end
