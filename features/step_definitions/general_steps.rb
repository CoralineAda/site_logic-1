Then %r/the (.+) element with the id (.+) should be visible/ do |elem, id|
  page.has_xpath?("//#{elem}[@id='#{id}']") && (page.should have_no_xpath("//#{elem}[@style='display:none' and @id='#{id}']"))
end

Then %r/the (.+) element with the id (.+) should not be visible/ do |elem, id|
  page.has_xpath?("//#{elem}[@style='display:none' and @id='#{id}']")
end
