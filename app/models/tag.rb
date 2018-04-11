class Tag < ApplicationRecord
  belongs_to :post
  belongs_to :category
  validates :category, uniqueness: { scope: :post_id }
end
