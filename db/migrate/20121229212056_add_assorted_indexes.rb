class AddAssortedIndexes < ActiveRecord::Migration
  def change
    add_index :akas, :email
    add_index :openid_trust_roots, [:aka_id, :trust_root], unique: true
    add_index :password_resets, :aka_id
    add_index :profile_links, :aka_id
    add_index :profile_pages, :aka_id, unique: true
    add_index :open_id_associations, [:server_url, :handle]
    add_index :open_id_nonces, [:timestamp, :server_url, :salt]
  end
end
