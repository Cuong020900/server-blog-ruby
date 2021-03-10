class ChangeUserAddOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :organization_id, :bigint
    add_foreign_key :users, :organizations
  end
end
