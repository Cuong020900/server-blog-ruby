class CreateClips < ActiveRecord::Migration[6.0]
  def change
    create_table :clips do |t|
      t.bigint :post_id
      t.bigint :user_id
    end

    create_table :follower do |t|
      t.bigint :follower_user_id
      t.bigint :user_id
    end
  end
end
