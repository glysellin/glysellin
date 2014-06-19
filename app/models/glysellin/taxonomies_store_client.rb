module Glysellin
  class TaxonomiesStoreClient < ActiveRecord::Base
    belongs_to :taxonomy, class_name: 'Glysellin::Taxonomy'
    belongs_to :store_client, class_name: 'Glysellin::StoreClient'
  end
end