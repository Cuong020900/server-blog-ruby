class ChangePostDefault < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :view, :integer, :default => 0
  end
end
