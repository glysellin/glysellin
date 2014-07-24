# This migration comes from glysellin_engine (originally 20140618214854)
class RenameVariantImagesToProductImages < ActiveRecord::Migration
  def up
    rename_table :glysellin_variant_images, :glysellin_images

    change_table :glysellin_images do |t|
      t.remove :variant_id
      t.references :imageable, polymorphic: true
    end
  end

  def down
    change_table :glysellin_images do |t|
      t.references :variant
      t.remove_references :imageable, polymorphic: true
    end

    rename_table :glysellin_images, :glysellin_variant_images
  end
end
