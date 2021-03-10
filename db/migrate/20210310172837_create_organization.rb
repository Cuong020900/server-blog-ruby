class CreateOrganization < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :avatar
      t.string :address
      t.string :description
      t.string :page

      t.timestamps
    end
  end
end
