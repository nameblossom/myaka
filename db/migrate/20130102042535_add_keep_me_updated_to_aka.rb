class AddKeepMeUpdatedToAka < ActiveRecord::Migration
  def change
    add_column :akas, :keep_me_updated, :boolean, default: true
  end
end
