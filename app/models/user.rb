class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # mount_uploader :avatar, AvatarUploader
  has_many :posts
  has_many :drafts, -> {where status: 'Draft'}, class_name: "Post"
  has_many :published_posts, -> {where status: 'Published'}, class_name: "Post"
  has_many :comments
  has_many :commented_posts, through: :comment, source: :post
  has_many :collects
  has_many :collected_posts, through: :collects, source: :post
  has_many :views
  has_many :viewed_posts, through: :views, source: :post
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :confirmed_friendships, -> {where status: 'confirmed'}, class_name: "Friendship"
  has_many :unconfirmed_friendships, -> {where status: 'unconfirmed'}, class_name: "Friendship"
  has_many :confirmed_friends, through: :confirmed_friendships, source: :friend
  has_many :unconfirmed_friends, through: :unconfirmed_friendships, source: :friend
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :confirmed_inverse_friendships, -> {where status: 'confirmed'}, class_name: "Friendship", foreign_key: "friend_id"
  has_many :unconfirmed_inverse_friendships, -> {where status: 'unconfirmed'}, class_name: "Friendship", foreign_key: "friend_id"
  has_many :confirmed_inverse_friends, through: :confirmed_inverse_friendships, source: :user
  has_many :unconfirmed_inverse_friends, through: :unconfirmed_inverse_friendships, source: :user

  def friend?(user)
    self.friends.include?(user)
  end

  def inverse_friend?(user)
    self.inverse_friends.include?(user)
  end

  def confirmed_friend?(user)
    self.confirmed_friendships.find_by(friend_id: user.id).nil? ? false : true
  end

  def confirmed_inverse_friend?(user)
    self.confirmed_inverse_friendships.find_by(user_id: user.id).nil? ? false : true
  end

  def all_friends()
    # (self.inverse_friends + self.friends).uniq
    self.confirmed_friends + self.confirmed_inverse_friends
  end 
end
