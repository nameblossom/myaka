class MakeSubdomainNotNull < ActiveRecord::Migration
  def change
    change_column :akas, :subdomain, :string, :null => false
  end
end
