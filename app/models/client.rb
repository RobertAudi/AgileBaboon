# == Schema Information
#
# Table name: clients
#
#  id            :integer         not null, primary key
#  account_name  :string(255)     not null
#  contact_name  :string(255)     not null
#  contact_email :string(255)     not null
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Client < ActiveRecord::Base
  after_create :create_client_database
  after_create :create_client_admin_user

  has_many :users
  has_many :issues

  attr_accessible :account_name, :contact_email, :contact_name

  validates :account_name, presence: true,
                           uniqueness: { case_sensitive: false },
                           length: { within: 4..42 },
                           format: { with: /^(?:[a-z][a-z0-9-]{2,40}[a-z0-9])$/ }

  validates :contact_name, presence: true,
                           length: { maximum: 255 },
                           format: { with: /^(?:[a-z0-9.-]+)(?: [a-z0-9.-]+)+$/i }

  validates :contact_email, presence: true,
                            length: { within: 8..255 },
                            format: { with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i }

  private

  # Create the client database (Apartment) for multi-tenancy
  def create_client_database
    begin
      Apartment::Database.create(self.account_name)
    rescue Apartment::SchemaExists
      return
    rescue
      self.destroy
    end
  end

  # Create an admin user for the client
  def create_client_admin_user
    Apartment::Database.switch(self.account_name)

    admin = ::User.create!(
      username: "admin",
      email: "admin@example.com",
      password: "admin",
      password_confirmation: "admin",
      admin: "1",
      client_id: self.id
    )

    # Add the superadmin roles to the admin
    admin.add_role :superadmin

    # Switch back to the root database
    Apartment::Database.switch
  end
end
