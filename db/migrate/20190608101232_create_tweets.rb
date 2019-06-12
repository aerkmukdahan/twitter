class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.string :content
      t.references :reply_to_tweet, index: true
      t.references :retweet_from_tweet, index: true

      t.timestamps
    end
  end
end
