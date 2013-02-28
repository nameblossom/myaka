class ProfileLink < ActiveRecord::Base
  attr_accessible :autofollow, :href, :title
  validates :href, presence: true, format: { with: /\Ahttps?\:\/\// }
  validates_presence_of :title, :rel
  belongs_to :aka
end
