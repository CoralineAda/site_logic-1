desc 'Pushes to remote repo if all features pass.'
task :push => :environment do
  OFF, GREEN, RED, YELLOW = "\e[0m", "\e[32m", "\e[31m", "\e[33m"

  # run cucumber with integration profile
  system 'cucumber --profile integration' rescue 0

  # read results
  results = open(Rails.application.config.feature_results_path).read

  # tally results
  failures = results.match(/(\d+) failed/)[0].to_i rescue 0
  passed = results.match(/(\d+) passed/)[0].to_i rescue 0
  total = results.match(/(\d+) scenario/)[0].to_i rescue 0
  undefined = results.match(/(\d+) undefined/)[0].to_i rescue 0

  tallies = []
  tallies << "#{RED}#{failures} failed#{OFF}" unless failures.zero?
  tallies << "#{YELLOW}#{undefined} undefined#{OFF}" unless undefined.zero?
  tallies << "#{GREEN}#{passed} passed#{OFF}" unless passed.zero?
  puts "#{total} scenarios (#{tallies * ', '})"

  if failures.zero?
    system 'git push'
  else
    puts "#{RED}Aborting push: failures detected!#{OFF}"
    puts results
  end
end
