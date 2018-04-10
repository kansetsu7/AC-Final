class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :content
      t.string :status
      t.string :authority
      t.integer :replies_count
      t.integer :viewed_count
      t.timestamps
    end
  end
end
