require "spec_helper"

describe Glysellin::Order do
  it { should have_many(:products) }
  it { should belong_to(:customer) }
  it { should have_many(:payments) }
  it { should belong_to(:shipping_method) }
  it { should have_many(:order_adjustments) }

  it { should accept_nested_attributes_for(:products) }
  it { should accept_nested_attributes_for(:payments) }
  it { should accept_nested_attributes_for(:order_adjustments) }

  it { should validate_presence_of(:billing_address) }
  it { should validate_presence_of(:shipping_address) }
  it { should validate_presence_of(:products) }

  describe "callbacks" do
    let(:order) { build(:order) }

    context "before validation" do
      it "processes adjustments" do
        expect(order).to receive(:process_adjustments)
        order.save
      end

      it "set payment state to paid if paid by check" do
        expect(order).to receive(:set_paid_if_paid_by_check)
        order.save
      end

      it "notifies shipping if needed" do
        expect(order).to receive(:notify_shipped)
        order.save
      end
    end

    context "after create" do
      it "ensures an order reference is set" do
        expect(order).to receive(:ensure_ref)
        order.save(validate: false)
      end

      it "ensures a customer address is present" do
        expect(order).to receive(:ensure_customer_addresses)
        order.save(validate: false)
      end
    end
  end

  describe "#ensure_ref" do
    let(:order) { build(:order) }

    it "sets the order reference to TIMESTAMP-ORDER_ID by defaut" do
      allow(order).to receive(:id) { 1234412 }
      order.ensure_ref
      expect(order.ref.split(/-/).pop).to eq("1234412")
    end

    it "uses Glysellin.order_reference_generator" do
      # Save default generator
      original_generator = Glysellin.order_reference_generator

      Glysellin.order_reference_generator = ->(order) { "REF" }
      order.ensure_ref
      expect(order.ref).to eq("REF")

      # Reset default generator
      Glysellin.order_reference_generator = original_generator
    end
  end

  describe "#ensure_customer_addresses" do
    let(:order) { build(:order) }

    it "adds order's billing address to the customer if customer doesn't have one yet" do
      order.customer.billing_address = nil
      order.ensure_customer_addresses
      expect(order.customer.billing_address.clone_attributes).to eq(
        order.billing_address.clone_attributes
      )
    end

    it "doesn't replace existing Customer#billing_address" do
      order.customer.billing_address = build(:address)
      order.ensure_customer_addresses
      expect(order.customer.billing_address.clone_attributes).not_to eq(
        order.billing_address.clone_attributes
      )
    end

    it "adds order's shipping address to the customer if needed" do
      order.customer.shipping_address = nil
      order.ensure_customer_addresses
      expect(order.customer.shipping_address.clone_attributes).to eq(
        order.shipping_address.clone_attributes
      )
    end

    it "doesn't replace existing Customer#shipping_address" do
      order.customer.billing_address = build(:address)
      order.customer.shipping_address = build(:address)
      order.ensure_customer_addresses
      expect(order.customer.shipping_address.clone_attributes).not_to eq(
        order.shipping_address.clone_attributes
      )
    end

    it "lets shipping address blank if billing address is the same as the shipping one" do
      order.shipping_address.assign_attributes(order.billing_address.clone_attributes)
      order.ensure_customer_addresses
      expect(order.customer.shipping_address).to be_nil
    end
  end
end