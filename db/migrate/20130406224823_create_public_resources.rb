class CreatePublicResources < ActiveRecord::Migration
  def change
    create_table :public_resources do |t|
      t.integer :aka_id
      t.string :path
      t.text :headers
      t.string :content_type
      t.binary :content
      t.string :etag
      t.timestamps
    end
    add_index :public_resources, [:aka_id, :path]
    Aka.all.each do |aka|	 
      aka.save!
    end
  end
end
