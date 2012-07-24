# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  username        :string(255)     not null
#  email           :string(255)     not null
#  password_digest :string(255)     not null
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  client_id       :integer
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :issues

  attr_accessible :email, :password, :password_confirmation, :username

  validates :username, presence: true,
                       length: { within: 4..50 },
                       format: { with: /(?:[\w\d]){4,255}/ }

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { within: 8..255 },
                    format: { with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i }

  validates :password, presence: true, on: :create,
                       confirmation: true,
                       length: { within: 4..255 }

  validates :password_confirmation, presence: true, on: :create

  # NOTE: Used by SimpleForm to display the dropdown proerply
  def to_label
    "#{username}"
  end
end
