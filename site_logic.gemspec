require './lib/version'
Gem::Specification.new do |s|
  s.name = "site_logic"
  s.version = SiteLogic::VERSION.dup
  s.summary = "An engine for search-engine-optimized content management."
  s.homepage = "http://github.com/ivanoblomov/site_logic"
  s.authors = ["Roderick Monje", "Bantik"]

  s.add_development_dependency 'cucumber-rails', '~>1'
  s.add_development_dependency 'database_cleaner', '~>0'
  s.add_development_dependency 'faker', '~>1'
  s.add_development_dependency 'machinist_mongo', '~>1'
  s.add_development_dependency 'mocha', '~>0.13'
  s.add_development_dependency 'rspec-rails', '~>2.13'

	s.add_runtime_dependency 'bson_ext', '~> 1'
	s.add_runtime_dependency 'cancan', '~> 1'
	s.add_runtime_dependency 'carrierwave-mongoid', '~> 0'
	s.add_runtime_dependency 'ckeditor', '~> 3.6.0'
	s.add_runtime_dependency 'kaminari', '~> 0'
	s.add_runtime_dependency 'mini_magick', '~> 3'
	s.add_runtime_dependency 'mongoid-tree', '~> 0'
	s.add_runtime_dependency 'rails', '~> 3'
	s.add_runtime_dependency 'rmagick', '~> 2'
	s.add_runtime_dependency 'scaffold_logic', '~> 2'
	s.add_runtime_dependency 'stringex', '~> 1'

  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split "\n"
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename f}
  s.require_paths = ["lib"]
end