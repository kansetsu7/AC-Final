class AddIntroToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :intro, :string
    add_column :users, :name, :string
    add_column :users, :avatar, :string
    add_column :posts, :image, :string
  end
end
