class ChangeContentType < ActiveRecord::Migration[5.1]
  def change
    change_column :comments, :content, :text
    change_column :posts, :content, :text
    change_column :users, :intro, :text
  end
end
