require 'rails_helper'

RSpec.describe User, type: :model do

  let(:valid_user){ described_class.create(
    email: "test@test.com",
    password: "123456",
    name: "test"
  ) }

  context "validation" do

    it "is valid with valid attributes" do
      expect(valid_user).to be_valid
    end

    it "is not valid without a email" do
      valid_user.email = nil
      expect(valid_user).to_not be_valid
    end

    it "is not valid without a password" do
      valid_user.password = ""
      expect(valid_user).to_not be_valid
    end

    it "is not valid without a name" do
      valid_user.name = nil
      expect(valid_user).to_not be_valid
    end

    it "is not valid with under 6 char password" do
      valid_user.password = "12345"
      expect(valid_user).to_not be_valid
    end

  end

  context "duplication" do

    subject{ described_class.new(
      email: "test2@test.com",
      password: "7891011",
      name: "test2"
    ) }

    it "is not valid with duplicate a email" do
      valid_user.save
      subject.email = "test@test.com"
      expect(subject).to_not be_valid
    end

    it "is valid with duplicate a password" do
      valid_user.save
      subject.password = "123456"
      expect(subject).to be_valid
    end

    it "is valid with duplicate a name" do
      valid_user.save
      subject.name = "test"
      expect(subject).to be_valid
    end

  end

  context "Associations" do
    it { should have_many(:tweets) }
    it { should have_many(:likes) }
    it { should have_many(:liked_tweets) }
    it { should have_many(:follower_associations) }
    it { should have_many(:followers) }
    it { should have_many(:following_associations) }
    it { should have_many(:followings) }
  end

end
