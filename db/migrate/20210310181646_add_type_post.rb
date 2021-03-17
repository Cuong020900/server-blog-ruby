class AddTypePost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :post_type, :integer, :default => 0
  end
end
