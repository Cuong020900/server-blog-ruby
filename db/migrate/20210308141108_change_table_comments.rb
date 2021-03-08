class ChangeTableComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :pid, :integer, :default => nil, :null => true
  end
end
