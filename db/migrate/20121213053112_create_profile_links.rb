class CreateProfileLinks < ActiveRecord::Migration
  def change
    create_table :profile_links do |t|
      t.string :href
      t.string :title
      t.boolean :autofollow
      t.integer :aka_id

      t.timestamps
    end
  end
end
