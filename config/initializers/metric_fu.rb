require 'metric_fu'

MetricFu::Configuration.run do |config|
  config.metrics  = [:churn, :saikuro, :stats, :flog, :flay]
  config.graphs   = [:flog, :flay, :stats]
  config.rcov[:test_files] = ['spec/**/*_spec.rb']
  config.rcov[:rcov_opts] << '-Ispec' # Needed to find spec_helper
end
