require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:valid_user) do
    described_class.new( email: 'abc@abc.com', password: '12341234' )
  end

  describe 'calid user' do
    it 'is valid user' do
        expect( valid_user ).to be_valid
    end

end
