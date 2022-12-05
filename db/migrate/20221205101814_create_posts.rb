class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :description, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
