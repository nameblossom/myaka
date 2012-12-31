class AddUniqueIndexToAkaSubdomain < ActiveRecord::Migration
  def change
    add_index :akas, :subdomain, unique:true
  end
end
