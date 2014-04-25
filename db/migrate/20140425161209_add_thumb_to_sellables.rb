class AddThumbToSellables < ActiveRecord::Migration
  def change
    add_column :glysellin_sellables, :thumb, :string
  end
end
