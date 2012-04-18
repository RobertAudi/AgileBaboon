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
  attr_accessible :account_name, :contact_email, :contact_name

  validates :account_name, :presence => true,
                           :uniqueness => { :case_sensitive => false },
                           :length => { :within => 4..42 },
                           :format => { :with => /^(?:[a-z][a-z0-9-]{2,40}[a-z0-9])$/ }

  validates :contact_name, :presence => true,
                           :length => { :maximum => 255 },
                           :format => { :with => /^(?:[a-z0-9-]+) (?:[a-z0-9-]+)$/i }

  validates :contact_email, :presence => true,
                            :length => { :within => 8..255 },
                            :format => { :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i }
end
