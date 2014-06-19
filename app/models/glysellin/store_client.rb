module Glysellin
  class StoreClient < ActiveRecord::Base
    self.table_name = 'glysellin_store_clients'

    validates :name, :key, presence: true

    before_validation :ensure_key
    belongs_to :store

    belongs_to :default_taxonomy, class_name: 'Glysellin::Taxonomy', foreign_key: 'default_taxonomy_id'

    has_many :taxonomies_store_clients
    has_many :taxonomies, through: :taxonomies_store_clients, class_name: 'Glysellin::Taxonomy'

    def ensure_key
      self.key ||= rand(100**10).to_s(36)
    end
  end
end
