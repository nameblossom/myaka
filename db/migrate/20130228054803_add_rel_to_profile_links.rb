class AddRelToProfileLinks < ActiveRecord::Migration
  def change
    add_column :profile_links, :rel, :string, default: 'https://aka.nu/Profile'
  end
end
