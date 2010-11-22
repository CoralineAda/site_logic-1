namespace :site_logic do

  desc "Install SiteLogic into your application."
  task :install do
    dir = Gem.searcher.find('site_logic').full_gem_path 
    system "rsync -ruv #{dir}/config/initializers/site_logic.rb config/initializers/"
    puts
    puts "========================================================================================="
    puts "SiteLogic installation complete."
    puts "========================================================================================="
    puts
    puts "Run rake site_logic:views if you want to customize views for your application."
    puts
    puts "========================================================================================="
    puts
  end

  desc "Copy views from SiteLogic into the host application"
  task :views do
    dir = Gem.searcher.find('site_logic').full_gem_path 
    system "rsync -ruv #{dir}/app/views/admin app/views/"
    system "rsync -ruv #{dir}/app/views/admin app/sites/"
    system "rsync -ruv #{dir}/app/views/admin app/pages/"
  end
      
end