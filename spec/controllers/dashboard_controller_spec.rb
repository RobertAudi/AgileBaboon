require 'spec_helper'

describe DashboardController do

  let(:client) { create(:client, :account_name => "acme") }

  before(:each) do
    @request.host = "#{client.account_name}.lvh.me"
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
