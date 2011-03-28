namespace :cucumber do
  desc 'Run cucumber features.'
  Cucumber::Rake::Task.new(:integration) do |t|
    t.profile = 'integration'
  end
end
