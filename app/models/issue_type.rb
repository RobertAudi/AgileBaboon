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

  before_save :format_label

  validates :label, :presence => true,
                    :uniqueness => { case_sensitive: false },
                    :length => { within: 3..10 }

  private

  def format_label
    self.label.upcase
  end
end
