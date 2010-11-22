Given /^I have sites named (.+)$/ do |names|
  names.split(', ').each do |name|
    p = Site.make(:name => "#{name}")
  end
end

Given /^I have no sites$/ do 
  Site.delete_all
end

Then /^I should have ([0-9]+) site$/ do |count|
  Site.count.should == count.to_i
end

When /^I visit "(.+)"$/ do |site|
  site = Site.where(:name => site).first
  visit admin_site_url(site)
end

