class HashTagAssociation < ApplicationRecord
    belongs_to :hash_tag
    belongs_to :tweet
end
