class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, unique: true
      t.string :name
      t.string :password_digest
      t.string :avatar
      t.string :address

      t.timestamps
    end
  end
end
