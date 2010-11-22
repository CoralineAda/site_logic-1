require 'machinist/mongoid'
require 'sham'
require 'faker'

Site.blueprint do
  name { Faker::Lorem.words(5) * " " }
  domain  { "www#{rand(1000)}.#{Faker::Internet.domain_name}" }
end
