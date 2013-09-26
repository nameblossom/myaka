class ProfilePage < ActiveRecord::Base
  belongs_to :aka
  #attr_accessible :profile_source
  after_save :update_home_page

  def update_home_page
    self.aka.update_resources
  end
end
