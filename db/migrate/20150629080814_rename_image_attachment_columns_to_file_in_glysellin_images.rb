class RenameImageAttachmentColumnsToFileInGlysellinImages < ActiveRecord::Migration
  def change
    rename_column :glysellin_images, :image_file_name, :file_file_name
    rename_column :glysellin_images, :image_content_type, :file_content_type
    rename_column :glysellin_images, :image_file_size, :file_file_size
    rename_column :glysellin_images, :image_updated_at, :file_updated_at
  end
end
