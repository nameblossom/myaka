class AddTentServer < ActiveRecord::Migration
  def change
    add_column :akas, :tent_server, :string
  end
end
