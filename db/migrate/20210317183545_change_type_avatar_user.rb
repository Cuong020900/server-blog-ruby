class ChangeTypeAvatarUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :avatar, :blob
  end
end
