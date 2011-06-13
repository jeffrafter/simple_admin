# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Thing.create(:name => "Thing One", :mood => "Mischevious")
Thing.create(:name => "Thing Two", :mood => "Sleepy")

Outfit.create(:kind => 'Pajamas', :thing => Thing.first)
