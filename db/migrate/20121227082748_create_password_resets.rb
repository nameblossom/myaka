class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :password_resets do |t|
      t.integer :aka_id
      t.timestamp :expiration
      t.string :key

      t.timestamps
    end
  end
end
