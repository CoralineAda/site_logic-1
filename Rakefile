require 'metric_fu'
require 'rubygems'
require 'rake'
require File.expand_path('../config/application', __FILE__)

SiteLogic::Application.load_tasks

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "site_logic"
    gem.summary = %Q{An engine for search-engine-optimized content management.}
    gem.description = %Q{An engine for search-engine-optimized content management.}
    gem.email = "corey@seologic.com"
    gem.homepage = "http://github.com/Bantik/site_logic"
    gem.authors = ["Bantik"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "site_logic #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
