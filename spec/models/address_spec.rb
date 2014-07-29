require "spec_helper"

describe Glysellin::Address do
  it { should belong_to(:shipped_addressable) }
  it { should belong_to(:billed_addressable) }

  describe 'validations' do
    context 'validates presence of company_name if first_name is present' do
      before { subject.first_name = :first_name }
      it { should_not validate_presence_of(:company_name) }
    end

    context 'validates presence of company_name if first_name is present' do
      before { subject.first_name = nil }
      it { should validate_presence_of(:company_name) }
    end

    context 'validates presence of first_name if company_name is present' do
      before { subject.company_name = :company_name }
      it { should_not validate_presence_of(:first_name) }
      it { should_not validate_presence_of(:last_name) }
    end

    context 'validates presence of first_name if company_name is present' do
      before { subject.company_name = nil }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
    end
  end

  describe '#location_string' do
    zip = '75014'
    city = 'Paris'
    country = 'France'

    [
      [true, true,    true, '75014, Paris, France'],
      [true, true,   false, '75014, Paris'],
      [true, false,   true, '75014, France'],
      [true, false,  false, '75014'],
      [false, true,   true, 'Paris, France'],
      [false, true,  false, 'Paris'],
      [false, false,  true, 'France'],
      [false, false, false, '']
    ].each do |(zip_presence, city_presence, country_presence, expected_result)|

      it "fills the address with following arguments: {
        (
          #{zip_presence},
          #{city_presence},
          #{country_presence}
        )
      }" do
        address = build(:address)
        address.zip = zip_presence         ? zip     : nil
        address.city = city_presence       ? city    : nil
        address.country = country_presence ? country : nil

        expect(address.location_string).to eq expected_result
      end
    end
  end

  describe '#full_name' do
    first_name = 'First'
    last_name = 'Last'
    company_name = 'Company'

    [
      [true, true,    true, 'First Last Company'],
      [true, true,   false, 'First Last'],
      [true, false,   true, 'First Company'],
      [true, false,  false, 'First'],
      [false, true,   true, 'Last Company'],
      [false, true,  false, 'Last'],
      [false, false,  true, 'Company'],
      [false, false, false, '']
    ].each do |(first_name_presence, last_name_presence, company_name_presence, expected_result)|

      it "fills the address with following arguments: {
        (
          #{first_name_presence},
          #{last_name_presence},
          #{company_name_presence}
        )
      }" do
        address = build(:address)
        address.first_name = first_name_presence     ? first_name   : nil
        address.last_name = last_name_presence       ? last_name    : nil
        address.company_name = company_name_presence ? company_name : nil

        expect(address.full_name).to eq expected_result
      end
    end
  end
end
