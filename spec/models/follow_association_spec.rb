require 'rails_helper'

RSpec.describe FollowAssociation, type: :model do
  context "Associations" do
    it { should belong_to(:follower) }
    it { should belong_to(:following) }
  end
end
