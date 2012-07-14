# == Schema Information
#
# Table name: issues
#
#  id            :integer         not null, primary key
#  title         :string(255)     not null
#  description   :string(255)     not null
#  issue_type_id :integer         not null
#  user_id       :integer         not null
#  client_id     :integer         not null
#  closed_at     :datetime
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Issue < ActiveRecord::Base
  attr_accessible :client_id, :closed_at, :description, :issue_type_id, :title, :user_id

  belongs_to :issue_type
  belongs_to :user
  acts_as_tenant(:client)

  validates :title, presence: true

  validates :issue_type_id, presence: true,
                            numericality: { only_integer: true,
                                            greater_than: 0 }

  validates :user_id, presence: true,
                      numericality: { only_integer: true,
                                      greater_than: 0 }
end
