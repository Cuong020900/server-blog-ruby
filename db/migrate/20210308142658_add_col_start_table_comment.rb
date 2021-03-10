class AddColStartTableComment < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :star, :integer, :default => 5, :null => true
  end
end
