class CreateOpenidTrustRoots < ActiveRecord::Migration
  def change
    create_table :openid_trust_roots do |t|
      t.integer :aka_id
      t.string :trust_root

      t.timestamps
    end
  end
end
