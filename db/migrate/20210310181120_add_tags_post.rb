class AddTagsPost < ActiveRecord::Migration[6.0]
  def change
    change_table :posts do |t|
      t.column :tags, :json, :default => nil
    end
  end
end
