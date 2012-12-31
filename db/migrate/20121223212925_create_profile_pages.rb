class CreateProfilePages < ActiveRecord::Migration
  def change
    create_table :profile_pages do |t|
      t.integer :aka_id
      t.text :profile_source

      t.timestamps
    end
  end
end
