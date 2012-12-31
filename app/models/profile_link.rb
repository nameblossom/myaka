class ProfileLink < ActiveRecord::Base
  attr_accessible :autofollow, :href, :title
  validates :href, presence: true, format: { with: /^https?\:\/\// }
  validates_presence_of :title
  belongs_to :aka
end
