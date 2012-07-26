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

require 'spec_helper'

describe Client do
  before(:each) do
    @client = Client.new(:account_name => "acme",
                         :contact_name => "Aziz Light",
                         :contact_email => "aziz@azizlight.me")
  end

  describe "Client specifications" do
    context "account name" do
      it "should respond to account name" do
        @client.should respond_to(:account_name)
      end

      it "should have an account name (not nil)" do
        @client.account_name = nil
        @client.should_not be_valid
      end

      it "should have an account name (not empty)" do
        @client.account_name = ""
        @client.should_not be_valid
      end

      it "should be at least four characters long" do
        @client.account_name = "aaa"
        @client.should_not be_valid
      end

      it "should be forty-two characters long maximum" do
        @client.account_name = "a" * 43
        @client.should_not be_valid
      end

      it "should only contain valid characters" do
        # underscores are invalid
        @client.account_name = "invalid_account_name"
        @client.should_not be_valid

        # brackets are invalid
        @client.account_name = "<invalid"
        @client.should_not be_valid
        @client.account_name = "invalid>"
        @client.should_not be_valid
      end

      it "should not start by a number" do
        @client.account_name = "42invalid"
        @client.should_not be_valid
      end

      it "should not end by a dash" do
        @client.account_name = "invalid-"
        @client.should_not be_valid
      end

      it "should be unique" do
        client = create(:client)
        client2 = Client.new(:account_name => client.account_name,
                             :contact_name => "Client Number Two",
                             :contact_email => "client2@example.com")
        client2.should_not be_valid
      end
    end

    context "contact name" do
      it "should respond to contact_name" do
        @client.should respond_to(:contact_name)
      end

      it "should have an contact name (not nil)" do
        @client.contact_name = nil
        @client.should_not be_valid
      end

      it "should have an contact name (not empty)" do
        @client.contact_name = ""
        @client.should_not be_valid
      end

      it "should not contain underscores" do
        @client.contact_name = "aziz_light"
        @client.should_not be_valid
      end

      it "should contain a forename and a surname" do
        @client.contact_name = "AzizLight"
        @client.should_not be_valid
      end

      it "should be 255 characters maximum" do
        @client.contact_name = "a" * 256
        @client.should_not be_valid
      end
    end

    context "contact email" do
      it "should respond to contact_email" do
        @client.should respond_to(:contact_email)
      end

      it "should have an contact email (not nil)" do
        @client.contact_email = nil
        @client.should_not be_valid
      end

      it "should have an contact email (not empty)" do
        @client.contact_email = ""
        @client.should_not be_valid
      end

      it "should have at least eight characters" do
        @client.contact_email = "a@b.c"
        @client.should_not be_valid
      end

      it "should not have more than 255 characters" do
        @client.contact_email = "a" * 127 + "@" + "b" * 124 + ".com"
        @client.should_not be_valid
      end

      it "should be a valid email" do
        invalid_emails = %w(invalid_email@example invalid@email@example invalid user@foo,com user_at_foo.org example.user@foo.)
        invalid_emails.each do |invalid_email|
          @client.contact_email = invalid_email
          @client.should_not be_valid
        end
      end
    end
  end
end
