class CreateParcelLineItems < ActiveRecord::Migration
  def change
    create_table :glysellin_parcel_line_items do |t|
      t.references :parcel, index: true
      t.references :line_item, index: true
      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
