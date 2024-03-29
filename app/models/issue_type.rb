# == Schema Information
#
# Table name: issue_types
#
#  id         :integer         not null, primary key
#  label      :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class IssueType < ActiveRecord::Base
  attr_accessible :label

  has_many :issues

  before_save :format_label

  validates :label, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { within: 3..10 }

  # NOTE: Used by SimpleForm to display the dropdown proerply
  def to_label
    "#{label}"
  end

  private

  def format_label
    self.label.upcase
  end
end
