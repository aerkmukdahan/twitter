require 'rails_helper'

RSpec.describe HashTagAssociation, type: :model do
  context "Associations" do
    it { should belong_to(:hash_tag) }
    it { should belong_to(:tweet) }
  end
end
