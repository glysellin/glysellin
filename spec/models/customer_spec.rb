require 'spec_helper'

describe Glysellin::Customer do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }

  before(:each) do
    @customer = create(:customer)
  end

  describe '.full_name' do
    it 'returns the full_name of Customer' do
      @customer.first_name = 'abc'
      @customer.last_name = 'def'
      expect(@customer.full_name).to eq 'abc def'
    end
  end
end
