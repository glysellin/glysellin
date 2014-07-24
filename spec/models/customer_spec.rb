require 'spec_helper'

describe Glysellin::Customer do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  it { should have_many(:orders) }
  it { should belong_to(:user) }

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

  describe '.create' do
    it 'returns an errors if a user is associated to the customer but no email' do
      customer = build(:customer, user_id: 1, email: nil)
      expect(customer.save).to eq false
    end

    it 'doesnt return an error if the email is filled with a user_id' do
      customer = build(:customer, user_id: 1, email: 'email@example.com')
      expect(customer.save).to eq true
    end

    it 'doesnt return an error if neither email nor user_id are filled' do
      customer = build(:customer, user_id: nil, email: nil)
      expect(customer.save).to eq true
    end

    it 'validates uniqueness of email' do
      customer = create(:customer, email: 'email@example.com')
      customer_2 = build(:customer, email: 'email@example.com')
      expect(customer_2.save).to eq false
    end
  end
end
