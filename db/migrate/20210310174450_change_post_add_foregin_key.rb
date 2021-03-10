class ChangePostAddForeginKey < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :series_post_id, :bigint
    add_foreign_key :posts, :series_posts
  end
end
