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
  attr_accessible :client_id, :closed_at, :description, :issue_type_id, :title, :user_id, :project_id

  belongs_to :issue_type
  belongs_to :user
  belongs_to :client
  belongs_to :project

  validates :title, presence: { message: "The title is required" }

  validates :issue_type_id, presence: { message: "An issue type is required" },
                            numericality: { only_integer: true,
                                            greater_than: 0,
                                            message: "Invalid issue type" }

  validates :user_id, presence: { message: "A user is required" },
                      numericality: { only_integer: true,
                                      greater_than: 0,
                                      message: "Invalid user" }

  validates :client_id, presence: { message: "A client id is required" },
                        numericality: { only_integer: true,
                                        greater_than: 0,
                                        message: "Invalid client id" }

  validates :project_id, presence: { message: "A project id is required" },
                         numericality: { only_integer: true,
                                         greater_than: 0,
                                         message: "Invalid project id" }
end
