class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name # 名字
      t.text :authing_access_token # Authing 的 access token
      t.text :authing_id_token

      t.timestamps
    end
  end
end
