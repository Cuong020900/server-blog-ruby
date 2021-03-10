class CreateTableComments < ActiveRecord::Migration[6.0]
  def change
      create_table :comments do |t|
        t.integer :post_id
        t.text :content
        t.integer :cuid

        t.timestamps
      end
  end
end
