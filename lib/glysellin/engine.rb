require 'glysellin/helpers'
require 'glysellin/sellable'
require 'glysellin/engine/routes'

module Glysellin
  class Engine < ::Rails::Engine

    initializer "Include Helpers" do |app|
      ActiveSupport.on_load :action_controller do
        Helpers.include!
      end
    end

    initializer "Mix acts_as_sellable into ActiveRecord::Base" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, Sellable)
      end
    end

  end
end
