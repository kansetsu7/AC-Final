class View < ApplicationRecord
  belongs_to :post, counter_cache: :viewed_count
  belongs_to :user
  validates :user, uniqueness: { scope: :post_id }
end
