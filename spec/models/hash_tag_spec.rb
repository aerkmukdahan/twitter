require 'rails_helper'

RSpec.describe HashTag, type: :model do
  context "Associations" do
    it { should have_many(:hash_tag_associations) }
    it { should have_many(:tweets) }
  end
end
