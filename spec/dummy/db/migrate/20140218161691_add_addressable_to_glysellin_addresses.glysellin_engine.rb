# This migration comes from glysellin_engine (originally 20130311135842)
class AddAddressableToGlysellinAddresses < ActiveRecord::Migration
  def change
    add_column :glysellin_addresses, :addressable_type, :string
    add_column :glysellin_addresses, :addressable_id, :integer
  end
end
