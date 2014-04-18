# This migration comes from glysellin_engine (originally 20140418145406)
class AddImageToVariants < ActiveRecord::Migration
  def change
    drop_table :glysellin_product_images
    create_table :glysellin_variant_images do |t|
      t.string :name
      t.integer :imageable_id
      t.string :imageable_type
      t.add_attachment :image
      t.timestamps
    end
  end
end
