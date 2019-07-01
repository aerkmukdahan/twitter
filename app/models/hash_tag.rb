class HashTag < ApplicationRecord
    has_many :hash_tag_associations, dependent: :destroy
    has_many :tweets, through: :hash_tag_associations

    has_many :users, through: :tweets, source: :user
end
