require 'spec_helper'

describe Project do
  let(:client) { create(:client) }

  it { should have_many :issues }
  it { should have_and_belong_to_many :users }

  describe "Project specification" do
    context "name" do
      it "should have a name attribute" do
        Project.new(attributes_for(:project)).should respond_to :name
      end

      it "should require a name" do
        Project.new(attributes_for(:project, name: nil)).should_not be_valid
      end

      it "should not have a name that is too short" do
        Project.new(attributes_for(:project, name: 'aa')).should_not be_valid
      end

      it "should not have a name that is too long" do
        Project.new(attributes_for(:project, name: 'a' * 256)).should_not be_valid
      end
    end
  end
end
