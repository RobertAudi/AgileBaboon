class Kong::BaseController < ActionController::Base
  protect_from_forgery

  layout 'kong'

  include Kong::SessionsHelper

  before_filter :authorize
end

