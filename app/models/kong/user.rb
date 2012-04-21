class Kong::User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :password, :password_confirmation, :username

  validates :username, :presence => true,
                       :uniqueness => { :case_sensitive => false },
                       :length => { :within => 4..50 },
                       :format => { :with => /(?:[\w\d]){4,255}/ }

  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false },
                    :length => { :within => 8..255 },
                    :format => { :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i }

  validates :password, :presence => true, :on => :create,
                       :confirmation => true,
                       :length => { :within => 4..255 }

  validates :password_confirmation, :presence => true, :on => :create
end
