class CreateSeriesPost < ActiveRecord::Migration[6.0]
  def change
    create_table :series_posts do |t|
      t.string :name

      t.timestamps
    end
  end
end
