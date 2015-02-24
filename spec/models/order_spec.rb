require "spec_helper"

describe Glysellin::Order do
  it { should have_many(:payments) }
  it { should have_one(:cart) }
  it { should have_one(:invoice) }

  it { should belong_to(:customer) }
  it { should accept_nested_attributes_for(:payments) }

  it { should validate_presence_of(:customer) }
  it { should validate_presence_of(:billing_address) }
  it { should validate_presence_of(:line_items) }

  before(:each) do
    @order = create(:order)
  end

  context 'before validation' do
    it 'checks prices' do
      expect(@order).to receive(:process_total_price)
      @order.save
    end
  end

  describe "callbacks" do
    context "before validation" do
      it "processes adjustments" do
        expect(@order).to receive(:process_payments)
        @order.save
      end
    end
  end

  describe '#payment' do
    it 'returns the last order payment' do
      @order.payments << build(:payment)
      @order.save!
      expect(@order.payment).to eq @order.payments.last
    end
  end

  describe '#payment_method' do
    it 'returns the last order payment type if available' do
      @order.payments << build(:payment)
      @order.save!
      expect(@order.payment_method).to eq @order.payments.last.payment_method
    end

    it 'returns nil if the last order payment is not available' do
      expect(@order.payment_method).to eq nil
    end
  end

  describe '.to_be_shipped' do
    it 'returns orders to be shipped' do
      order_1 = create(:order, state: 'pending')
      order_2 = create(:order, state: 'pending')
      order_3 = create(:order, state: 'pending')
      order_4 = create(:order, state: 'completed')
      order_5 = create(:order, state: 'canceled')

      order_1.shipment = create(:shipment, state: 'shipped')
      order_2.shipment = create(:shipment, state: 'pending')
      order_3.shipment = create(:shipment)
      order_4.shipment = create(:shipment, state: 'pending')
      order_5.shipment = create(:shipment, state: 'pending')

      expect(Glysellin::Order.active.pluck(:id)).to eq [@order, order_1, order_2, order_3, order_4].map(&:id)
      expect(Glysellin::Order.to_be_shipped.pluck(:id)).to eq [order_2, order_3, order_4].map(&:id)
    end
  end
end
