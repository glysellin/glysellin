# This migration comes from glysellin_engine (originally 20140620145659)
class CreateGlysellinImageables < ActiveRecord::Migration
  def change
    create_table :glysellin_imageables do |t|
      t.integer :imageable_owner_id
      t.string :imageable_owner_type
      t.integer :image_id

      t.timestamps
    end
  end
end
