class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: :replies_count
  # scope :latest, -> {order('created_at DESC').first}
  scope :latest_time, -> {order('created_at DESC').first.created_at.strftime('%F')}
end
