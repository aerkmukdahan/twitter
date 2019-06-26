class AddRefUserToTweets < ActiveRecord::Migration[5.2]
  def change
    add_reference :tweets, :user, null: false, foreign_key: true
  end
end
