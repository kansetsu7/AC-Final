class Post < ApplicationRecord
  # mount_uploader :image, PostImageUploader
  before_save :check_title
  after_save :update_counter_cache
  after_destroy :update_counter_cache
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments
  has_many :replied_users, through: :comments, source: :user
  has_many :views
  scope :published, -> {where(status: 'Published')}

  def create_date
    self.created_at.strftime('%F')
  end

  def check_title
    self.title = 'No title' if self.title == ''
  end

  def update_counter_cache
    self.user.posts_count = self.user.published_posts.count
    self.user.save
  end

  def self.readable_posts(user)
    Post.where(authority: "Friend", user: user.all_friends).or( where(authority: "All")).or(where(authority: "Myself", user: user)).or(where( user: user))
  end

  def readable?(user)
    Post.readable_posts(user).published.include?(self)
  end
end
