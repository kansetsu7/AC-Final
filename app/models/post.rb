class Post < ApplicationRecord
  # mount_uploader :image, PostImageUploader
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments
  has_many :replied_users, through: :comments, source: :user
  has_many :views
end
