require 'spec_helper'

describe Kong::BaseController do
  before(:each) do
    @request.host = "kong.lvh.me"
  end

  it "should inherit from ActionController::Base" do
    Kong::BaseController.superclass.should == ActionController::Base
  end
end
