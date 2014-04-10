class CreateGlysellinPackages < ActiveRecord::Migration
  def change
    create_table :glysellin_parcels do |t|
      t.string :name
      t.integer :sendable_id
      t.string :sendable_type

      t.timestamps
    end
  end
end
