# This migration comes from glysellin_engine (originally 20140428132703)
class MoveVariantImagesImageableRelationToSimpleBelongsToVariant < ActiveRecord::Migration
  def up
    change_table :glysellin_variant_images do |t|
      t.remove_references :imageable, polymorphic: true
      t.references :variant
    end
  end

  def down
    change_table :glysellin_variant_images do |t|
      t.remove_references :variant
      t.references :imageable, polymorphic: true
    end
  end
end
