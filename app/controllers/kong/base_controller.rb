class Kong::BaseController < ActionController::Base
  protect_from_forgery

  layout 'kong'
end
