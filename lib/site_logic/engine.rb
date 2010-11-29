require 'site_logic'
require 'rails'

module SiteLogic
  class Engine << Rails::Engine
    engine_name :site_logic
  end
end
