require 'spec_helper'

describe IssueType do
  let(:attr) { { label: "BUG" } }

  it { should have_many :issues }

  describe "Issue Type specification" do
    context "label" do
      it "should have a label attribute" do
        IssueType.new(attr).should respond_to(:label)
      end

      it "should require a label" do
        IssueType.new(attr.merge(label: "")).should_not be_valid
      end

      it "should require a unique label" do
        IssueType.create!(attr)
        IssueType.new(attr).should_not be_valid
      end

      it "should require a unique label up to case" do
        IssueType.create!(attr)
        IssueType.new(attr.merge(label: "bug")).should_not be_valid
      end

      it "should have a minimum length of 3" do
        IssueType.new(label: "BU").should_not be_valid
      end

      it "should have a maximum length of 10" do
        IssueType.new(label: "B" * 11).should_not be_valid
      end
    end
  end
end
