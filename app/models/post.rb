class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  belongs_to :user
  has_many :tags
  has_many :categories, through: :tags, source: :category
  has_many :comments
  has_many :replied_users, through: :comments, source: :user
  has_many :views
end
