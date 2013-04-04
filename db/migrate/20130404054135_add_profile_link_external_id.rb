require 'securerandom'

class AddProfileLinkExternalId < ActiveRecord::Migration
  def up
    add_column :profile_links, :external_id, :string
    ProfileLink.all.each do |link|
      link.external_id = SecureRandom.uuid
      link.save
    end
  end

  def down
    remove_column :profile_links, :external_id
  end
end
