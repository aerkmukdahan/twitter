class CreateFollowAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_associations do |t|
      t.integer "follower_id"
      t.integer "following_id"
      
      t.timestamps
    end
  end
end
