require 'glysellin/helpers'
require 'glysellin/orderer'
require 'glysellin/engine/routes'

module Glysellin
  class Engine < ::Rails::Engine
    initializer "Include Helpers" do |app|
      ActiveSupport.on_load :action_controller do
        %w(Controller Countries Views).each do |helper|
          ActionController::Base.send(:include, Helpers.const_get(helper))
        end
      end
    end

    initializer "Mix acts_as_sellable into ActiveRecord::Base" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, ActsAsOrderer)
      end
    end

  end
end
