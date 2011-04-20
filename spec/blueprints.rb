require 'machinist/mongoid'
require 'sham'
require 'faker'

Site.blueprint do
  name    { Faker::Lorem.words(5) * " " }
  domain  { "www#{rand(1000)}.#{Faker::Internet.domain_name}" }
end

Page.blueprint do
  page_title  { Faker::Lorem.words(5) * " " }
  slug        { Faker::Lorem.words(5) * "_" }
  content     { "Some content" }
end

NavItem.blueprint do
  kind        { 'Primary' }
  url         { Faker::Lorem.words(5) * "_" }
  link_text   { Faker::Lorem.words(5) * " " }
  link_title  { Faker::Lorem.words(5) * " " }
end