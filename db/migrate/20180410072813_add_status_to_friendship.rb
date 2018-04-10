class AddStatusToFriendship < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :status, :string, :default => 'unconfirmed'
  end
end
