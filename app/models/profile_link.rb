require 'securerandom'

class ProfileLink < ActiveRecord::Base
  attr_accessible :autofollow, :href, :title
  validates :href, presence: true, format: { with: /\Ahttps?\:\/\// }
  validates_presence_of :title, :rel
  belongs_to :aka

  before_save :set_default
  after_save :update_profile
  after_destroy :update_profile

  protected
  
  def set_default
    self.external_id ||= SecureRandom.uuid
  end

  def update_profile
    self.aka.update_resources
  end

end
