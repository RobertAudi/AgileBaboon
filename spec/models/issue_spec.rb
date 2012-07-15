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

require 'spec_helper'

describe Issue do
  let(:issue_type) { create(:issue_type) }
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let(:attr) do
    {
      :title => "Finish the AgileBaboon project",
      :description => "I should try to finish the AgileBaboon project",
      :issue_type_id => issue_type.id
    }
  end

  it { should belong_to :issue_type }
  it { should belong_to :user }

  describe "Issue specification" do
    context "title" do
      it "should have a title attribute" do
        Issue.new(attr).should respond_to :title
      end

      it "should require a title" do
        Issue.new(attr.merge(:title => "")).should_not be_valid
      end
    end

    context "description" do
      it "should have a description attribute" do
        Issue.new(attr).should respond_to :description
      end
    end

    context "Issue type" do
      it "should have an issue_type_id attribute" do
        Issue.new(attr).should respond_to :issue_type_id
      end

      it "should require an issue_type_id" do
        Issue.new(attr.merge(:issue_type_id => nil)).should_not be_valid
      end
    end

    context "User" do
      it "should have a user_id attribute" do
        Issue.new(attr).should respond_to :user_id
      end

      it "should require a user id" do
        Issue.new(attr.merge(:user_id => nil)).should_not be_valid
      end
    end

    context "Client" do
      it "should have a client_id attribute" do
        Issue.new(attr).should respond_to :client_id
      end

      it "should require a client id" do
        Issue.new(attr.merge(:client_id => nil)).should_not be_valid
      end
    end
  end
end
