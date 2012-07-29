# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  username        :string(255)     not null
#  email           :string(255)     not null
#  password_digest :string(255)     not null
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  client_id       :integer
#

require 'spec_helper'

describe User do
  let(:client) { create(:client) }
  let(:attr) do
    {
      username: "user",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
      client_id: client.id,
      admin: "0"
    }
  end

  it { should belong_to :client }
  it { should have_many :issues }

  describe "User specification" do
    context "username" do
      it "should have a username attribute" do
        User.new(attr).should respond_to(:username)
      end

      it "should require a username" do
        User.new(attr.merge(:username => '')).should_not be_valid
      end

      it "should require a unique username" do
        User.create!(attr)
        User.new(attr.merge(:email => "user2@example.com")).should_not be_valid
      end

      it "should have a minimum length of 4" do
        User.new(attr.merge(:username => "aaa")).should_not be_valid
      end

      it "should have a maximum length of 50" do
        User.new(attr.merge(:username => "a" * 51)).should_not be_valid
      end
    end

    context "email" do
      it "should have an email attribute" do
        User.new(attr).should respond_to(:email)
      end

      it "should require an email" do
        User.new(attr.merge(:email => '')).should_not be_valid
      end

      it "should require a unique email" do
        User.create!(attr)
        User.new(attr.merge(:username => "user2")).should_not be_valid
      end

      it "should have a minimum length of 8 characters" do
        User.new(attr.merge(:email => 'aa@bb.c')).should_not be_valid
      end

      it "should have a maximum length of 255 characters" do
        User.new(attr.merge(:email => 'a' * 256)).should_not be_valid
      end

      it "should reject invalid emails" do
        %w[user@foo,com user_at_foo.org example.user@foo.].each do |email|
          User.new(attr.merge(:email => email)).should_not be_valid
        end
      end
    end

    context "password" do
      it "should have a password attribute" do
        User.new(attr).should respond_to(:password)
      end

      it "should have a password confirmation attribute" do
        User.new(attr).should respond_to(:password_confirmation)
      end

      it "should require a password" do
        User.new(attr.merge(:password => '', :password_confirmation => '')).should_not be_valid
      end

      it "should require a password confirmation matching the password" do
        User.new(attr.merge(:password_confirmation => '')).should_not be_valid
      end

      it "should a minimum length of 4 characters" do
        User.new(attr.merge(:password => 'aaa', :password_confirmation => 'aaa')).should_not be_valid
      end

      it "should a maximum length of 255 characters" do
        User.new(attr.merge(:password => 'a' * 256, :password_confirmation => 'a' * 256)).should_not be_valid
      end
    end

    context "client_id" do
      it "should have a client_id attribute" do
        User.new(attr).should respond_to(:client_id)
      end

      it "should require a client_id" do
        User.new(attr.merge(client_id: nil)).should_not be_valid
      end

      it "should require a valid client_id (only numbers)" do
        User.new(attr.merge(client_id: "fourty two")).should_not be_valid
      end
    end

    context "admin" do
      it "should have an admin attribute" do
        User.new(attr).should respond_to(:admin)
      end

      it "should require a value for admin" do
        User.new(attr.merge(admin: nil)).should_not be_valid
      end

      it "should require a valid value for admin" do
        User.new(attr.merge(admin: "zero")).should_not be_valid
      end
    end
  end
end
