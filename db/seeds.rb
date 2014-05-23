# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# USER NOTIFICATION
puts '*****************************'
puts "Note: RAILS_ENV=#{ENV['RAILS_ENV']}"
puts "Waiting for 10 secs"
sleep(10.seconds.to_i) # had to use seconds.to_i instead of just seconds in case of JRuby
puts '*****************************'

# REQUIRING FILES FROM SEEDS DIRECTORY IN SORTED ORDER
Dir.glob(File.join(Rails.root, 'db', 'seeds', '*.rb')).sort.each { |f| require f }

