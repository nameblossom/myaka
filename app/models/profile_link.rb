require 'securerandom'

class ProfileLink < ActiveRecord::Base
  attr_accessible :autofollow, :href, :title
  validates :href, presence: true, format: { with: /\Ahttps?\:\/\// }
  validates_presence_of :title, :rel
  belongs_to :aka

  before_save :set_default

  protected
  
  def set_default
    self.external_id ||= SecureRandom.uuid
  end

end
