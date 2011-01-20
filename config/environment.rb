# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path('../../lib/site_logic', __FILE__)

# Initialize the rails application
SiteLogic::Application.initialize!
