class PasswordReset < ActiveRecord::Base
  #attr_accessible :expiration, :key
  belongs_to :aka
end
