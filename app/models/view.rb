class View < ApplicationRecord
  belongs_to :post, counter_cache: :viewed_count
  belongs_to :user
end
