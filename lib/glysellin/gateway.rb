require 'glysellin/gateway/base'
require 'glysellin/gateway/paypal_integral'
require 'glysellin/gateway/atos'
require 'glysellin/gateway/cic'
require 'glysellin/gateway/check'

# system_pay is a Gem (located on Github)[github.com/youboox/system_pay]
# and we cannot depend on it. We should fork it and push it on Rubygems
begin
  require 'system_pay/railtie'
  require 'glysellin/gateway/systempay'
rescue LoadError => e
end

module Glysellin
  module Gateway
  end
end
