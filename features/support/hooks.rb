require File.expand_path(File.dirname(__FILE__) + '/../../spec/blueprints')
require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :truncation
