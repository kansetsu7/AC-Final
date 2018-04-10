class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  belongs_to :user
  has_many :tags
  has_many :tagged_categories, through: :tags, source: :category
  has_many :replies
  has_many :replied_users, through: :comments, source: :user
end
