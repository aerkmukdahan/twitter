class CreateHashTagAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :hash_tag_associations do |t|
        t.belongs_to :hash_tag, index: true
        t.belongs_to :tweet, index: true
        t.timestamps
    end
  end
end
