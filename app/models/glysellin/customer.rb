module Glysellin
  class Customer < ActiveRecord::Base
    self.table_name = 'glysellin_customers'

    validates_presence_of :first_name, :last_name, :email
  end
end
