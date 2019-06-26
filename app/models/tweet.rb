class Tweet < ApplicationRecord

    has_many :replies, class_name: 'Tweet', foreign_key: 'reply_to_tweet_id', dependent: :destroy
    belongs_to :reply_to_tweet, class_name: 'Tweet', optional: true

    has_many :retweets, class_name: 'Tweet', foreign_key: 'retweet_from_tweet_id'
    belongs_to :retweet_from_tweet, class_name: 'Tweet', optional: true

    validates :content, length: { maximum: 256, too_long: 'Your tweet is too long. You Can\'t tweet more than %{count} characters.' }
    validates :content, presence: { message: 'Your tweet is empty. You haven\'t typed anything yet.' }, unless: :retweet_from_tweet_id?

    belongs_to :user

    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user

    has_many :hash_tag_associations, dependent: :destroy
    has_many :hash_tags, through: :hash_tag_associations
end
