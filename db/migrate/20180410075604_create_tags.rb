class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.integer :post_id
      t.integer :category_id
      t.timestamps
    end

    remove_column :categories, :post_id

  end
end
