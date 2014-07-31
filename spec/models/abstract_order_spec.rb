require 'spec_helper'

describe Glysellin::AbstractOrder do
  it { should validate_presence_of(:customer) }

  it { should have_many(:parcels) }
  it { should have_many(:line_items) }
  it { should have_many(:discounts) }
  it { should have_one(:shipment) }

  it { should belong_to(:customer) }
  it { should belong_to(:store) }

  it { should accept_nested_attributes_for(:parcels) }
  it { should accept_nested_attributes_for(:shipment) }
  it { should accept_nested_attributes_for(:discounts) }

  it { should have_one(:shipment) }

  # context 'after creation' do
  #   it 'ensure_customer_addresses' do
  #     @abstract_order.save
  #     expect(@abstract_order).to receive(:ensure_customer_addresses)
  #   end

  #   it 'ensure_ref' do
  #     @abstract_order.save
  #     expect(@abstract_order).to receive(:ensure_ref)
  #   end
  # end

  before(:each) do
    @abstract_order = create(:abstract_order)
  end

  describe 'validations' do
    context 'validates presence of shipping_address if use_another_address_for_shipping is present' do
      before { subject.use_another_address_for_shipping = true }
      it { should validate_presence_of(:shipping_address) }
    end

    context 'does not validate presence of shipping_address if use_another_address_for_shipping is not present' do
      before { subject.use_another_address_for_shipping = false }
      it { should_not validate_presence_of(:shipping_address) }
    end
  end

  describe '#email' do
    it 'returns nil if customer is not present' do
      @abstract_order.customer = nil
      expect(@abstract_order.email).to eq nil
    end

    it 'returns customer email if customer is present' do
      @abstract_order.customer = create(:customer)
      expect(@abstract_order.email).to eq @abstract_order.customer.email
    end
  end

  describe "#ensure_ref" do
    it "sets the abstract_order reference to TIMESTAMP-ORDER_ID by defaut" do
      @abstract_order.ensure_ref
      expect(@abstract_order.ref.split(/-/).pop).to eq('1')
    end

    it "sets the abstract_order reference to TIMESTAMP-ORDER_ID if another :id" do
      @abstract_order.ref = '123456'
      @abstract_order.ensure_ref
      expect(@abstract_order.ref).to eq('123456')
    end

    it "uses Glysellin.order_reference_generator" do
      @abstract_order.ensure_ref
      expect(@abstract_order.ref).to eq "#{ Time.now.strftime('%Y%m%d%H%M') }-#{ @abstract_order.id }"
    end
  end

  describe '#name' do
    [
      [true,  true,         :customer],
      [true,  false,        :customer],
      [false, true,  :billing_address],
      [false, false,              nil]
    ].each do |(customer_presence, billing_address_presence, expected_result)|

      it "fills the abstract_order with following arguments: {
        (
          #{customer_presence},
          #{billing_address_presence},
          #{expected_result}
        )
      }" do
        @abstract_order.customer        = nil unless customer_presence
        @abstract_order.billing_address = nil unless billing_address_presence

        expected_result = @abstract_order.customer.full_name if (expected_result == :customer)
        expected_result = @abstract_order.billing_address.full_name if (expected_result == :billing_address)

        expect(@abstract_order.name).to eq expected_result
      end
    end
  end

  describe "#ensure_customer_addresses" do
    [
      [false, false, false, :to,      :not_to],
      [true, false, false,  :not_to, :not_to ],
      [false, true, false,  :to,      :not_to],
      [true, true, false,   :not_to,  :not_to],
      [false, false, true,  :to,          :to],
      [true, false, true,   :not_to,      :to],
      [false, true, true,   :to,      :not_to],
      [true, true, true,    :not_to,  :not_to]
    ].each do |(billing_address, shipping_address, use_another_address_for_shipping, comparator_1, comparator_2)|

      it "fills addresses with following arguments: {
        (
          #{billing_address},
          #{shipping_address},
          #{use_another_address_for_shipping},
          #{comparator_1},
          #{comparator_2}
        )
      }" do
        customer = @abstract_order.customer
        customer.billing_address = billing_address ? create(:address) : nil
        customer.shipping_address = shipping_address ? create(:address) : nil

        @abstract_order.use_another_address_for_shipping = use_another_address_for_shipping
        @abstract_order.ensure_customer_addresses

        for attribute in [:first_name, :last_name, :address, :zip, :city, :country]
          unless billing_address
            expect(customer.billing_address.send(attribute)).send(
              comparator_1, eq(@abstract_order.billing_address.send(attribute))
            )

            if use_another_address_for_shipping && !shipping_address
              expect(customer.shipping_address.send(attribute)).send(
                comparator_2, eq(@abstract_order.shipping_address.send(attribute))
              )
            end
          end
        end
      end
    end
  end
end
