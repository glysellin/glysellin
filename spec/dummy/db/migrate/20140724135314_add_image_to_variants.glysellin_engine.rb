# This migration comes from glysellin_engine (originally 20140418145406)
class AddImageToVariants < ActiveRecord::Migration
  def change
    drop_table :glysellin_product_images
    create_table :glysellin_variant_images do |t|
      t.string :name
      t.integer :imageable_id
      t.string :imageable_type
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end
end
