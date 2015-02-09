# This migration comes from glysellin_engine (originally 20140901140208)
class CreateGlysellinCustomerTypesVariants < ActiveRecord::Migration
  def change
    create_table :glysellin_customer_types_variants do |t|
      t.integer :variant_id
      t.integer :customer_type_id

      t.timestamps
    end
  end
end
