class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.string :content
      t.string :parent_tweet_id
      t.string :reply_id

      t.timestamps
    end
  end
end
