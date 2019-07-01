require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TweetsHelper. For example:
#
# describe TweetsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TweetsHelper, type: :helper do
  
  describe 'add_hash_tag_link' do

    let(:input){ 
      "Lorem #Ipsum"
    }

    it "is return text with <a> tag" do
      expected_output = "Lorem <a href=#{tweets_hash_tag_path("#Ipsum")}>#Ipsum</a>"
      expect( add_hash_tag_link( input ) ).to eq( expected_output )
    end
  end

end
