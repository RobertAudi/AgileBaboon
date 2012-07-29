class Project < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :issues
  has_and_belongs_to_many :users, join_table: "users_projects"

  validates :name, presence: { message: "A project needs a name" },
                   length: { minimum: 3,
                             maximum: 255,
                             too_short: "A project name must have a least 3 letters",
                             too_long: "A project name must have at most 255 letters" }
end
