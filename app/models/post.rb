class Post < ApplicationRecord
  # mount_uploader :image, PostImageUploader
  before_save :check_title
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments
  has_many :replied_users, through: :comments, source: :user
  has_many :views

  def create_date
    self.created_at.strftime('%F')
  end

  def check_title
    self.title = 'No title' if self.title == ''
  end
end
