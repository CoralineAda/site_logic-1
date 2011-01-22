require 'site_logic'
require 'rails'
module SiteLogic
  class Railtie < Rails::Railtie
    rake_tasks do
      dir = Gem.searcher.find('site_logic').full_gem_path
      load "#{dir}/tasks/site_logic.rake"
    end
  end
end