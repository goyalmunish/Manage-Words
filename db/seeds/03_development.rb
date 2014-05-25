# # REQUIRED ONLY FOR DEVELOPMENT # #
if ENV['RAILS_ENV']=='development'
  # USER NOTIFICATION
  puts "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  puts '** Refreshing all existing tables with seed data **'
  sleep(5.seconds.to_i)

  # SEEDING
  if User.count == 0
    User.create!(:first_name => 'Munish', :last_name => 'Goyal', :type => 'Admin', :email => 'munishapc@gmail.com', :password => 'munishgoyal', :password_confirmation => 'munishgoyal')
  end

end


