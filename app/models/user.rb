class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_many :tweets, dependent: :destroy

  has_many :hash_tags, through: :tweets, source: :hash_tags

  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  has_many :follower_associations, foreign_key: :following_id, class_name: 'FollowAssociation', dependent: :destroy
  has_many :followers, through: :follower_associations, source: :follower

  has_many :following_associations, foreign_key: :follower_id, class_name: 'FollowAssociation', dependent: :destroy
  has_many :followings, through: :following_associations, source: :following

  validates :name, presence: { message: 'of your user can\'t be empty.' }
  validates :email, uniqueness: true

end
