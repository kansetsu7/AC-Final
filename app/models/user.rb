class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader
  has_many :posts
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
end
