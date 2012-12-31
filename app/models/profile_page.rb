class ProfilePage < ActiveRecord::Base
  belongs_to :aka
  attr_accessible :profile_source
end
