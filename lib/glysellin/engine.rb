require 'glysellin/helpers'
require 'glysellin/orderer'
require 'glysellin/engine/routes'
require 'active_model_serializers'

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

    config.to_prepare do
      path = Rails.root.join('lib', 'decorators', 'glysellin', '**', '*.rb')

      Dir[path].each do |file|
        load file
      end
    end
  end
end
