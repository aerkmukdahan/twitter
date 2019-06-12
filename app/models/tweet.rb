class Tweet < ApplicationRecord
    belongs_to :parent_tweet, class_name: 'Tweet', foreign_key: 'parent_tweet_id', optional: true
    has_many :reply, class_name: 'Tweet', foreign_key: 'reply_id'

    belongs_to :parent_retweet, class_name: 'Tweet', foreign_key: 'retweet_id', optional: true
end
