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
