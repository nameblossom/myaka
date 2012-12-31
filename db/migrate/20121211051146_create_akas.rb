class CreateAkas < ActiveRecord::Migration
  def change
    create_table :akas do |t|
      t.string :subdomain
      t.string :email
      t.string :display_name
      t.string :password_digest

      t.timestamps
    end
  end
end
