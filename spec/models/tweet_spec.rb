require 'rails_helper'

RSpec.describe Tweet, type: :model do

  let(:user){ User.create(
    email: "test@test.com",
    password: "123456",
    name: "test"
  ) }

  context "user" do
    it "is valid" do
      expect(user).to be_valid
    end
  end

  let(:valid_tweet){ described_class.create(
    content: "This tweet created by RSpec for test.",
    user_id: user.id,
    user: user
  ) }

  context "validation" do

    it "is valid with valid attributes" do
      expect(valid_tweet).to be_valid
    end

    it "is not valid without a content" do
      valid_tweet.content = nil
      expect(valid_tweet).to_not be_valid
    end

    it "is not valid without a user" do
      valid_tweet.user = nil
      expect(valid_tweet).to_not be_valid
    end

    it "is not valid with over 256 char content" do
      valid_tweet.content = 
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris 
        aliquet vehicula lacus vitae gravida. Praesent scelerisque vestibulum 
        nibh, a vulputate nisl pellentesque quis. Vivamus eget venenatis 
        mauris. Vestibulum ante ipsum primis in faucibus posuere."
      expect(valid_tweet).to_not be_valid
    end

  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:replies) }
    it { should have_many(:retweets) }
    it { should have_many(:likes) }
    it { should have_many(:liked_users) }
    it { should have_many(:hash_tag_associations) }
    it { should have_many(:hash_tags) }
  end

  context ".root_tweets" do

    let(:reply_tweet){ described_class.create(
      content: "This reply created by RSpec for test.",
      user_id: user.id,
      user: user,
      reply_to_tweet: valid_tweet
    ) }

    let(:retweet_tweet){ described_class.create(
      content: "This retweet created by RSpec for test.",
      user_id: user.id,
      user: user,
      retweet_from_tweet: valid_tweet
    ) }

    it "is return tweet" do
      expect(described_class.root_tweets).to be_include(valid_tweet)
    end

    it "is not return reply" do
      expect(described_class.root_tweets).to_not be_include(reply_tweet)
    end

    it "is return retweet" do
      expect(described_class.root_tweets).to be_include(retweet_tweet)
    end

  end

end
