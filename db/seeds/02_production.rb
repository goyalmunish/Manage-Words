# # REQUIRED FOR ONLY PRODUCTION # #
if ENV['RAILS_ENV']=='production'
  # USER NOTIFICATION
  puts "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  puts '** <put description or caution here **'
  sleep(5.seconds.to_i)

  # SEEDING
  if User.count == 0
    User.create!(:first_name => 'Munish', :last_name => 'Goyal', :type => 'Admin', :email => 'munishapc@gmail.com', :password => 'munishgoyal', :password_confirmation => 'munishgoyal')
  end
  
end
