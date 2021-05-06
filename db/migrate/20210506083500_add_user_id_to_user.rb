class AddUserIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :authing_user_id, :string
    # 在 Authing 那边用户 ID 有时候也叫做 sub
  end
end
