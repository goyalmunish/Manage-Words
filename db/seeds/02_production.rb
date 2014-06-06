# # REQUIRED FOR ONLY PRODUCTION # #
if ENV['RAILS_ENV']=='production'
  # USER NOTIFICATION
  puts "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  puts '** <put description or caution here **'
  sleep(5.seconds.to_i)

  # SEEDING
  if User.count == 0
    User.create!(:first_name => 'Munish', :last_name => 'Goyal', :type => 'Admin', :email => 'munishapc@gmail.com', :password => 'munishgoyal', :password_confirmation => 'munishgoyal')
    User.create!(:first_name => 'Ritika', :last_name => 'Goyal', :type => 'General', :email => 'ritikamittal9@gmail.com', :password => 'munishgoyal', :password_confirmation => 'munishgoyal')
    User.create!(:first_name => 'Manish', :last_name => 'Arya', :type => 'General', :email => 'coolaryan54@gmail.com', :password => 'rahularya', :password_confirmation => 'rahularya')
    User.create!(:first_name => 'Geetika', :last_name => 'Mittal', :type => 'General', :email => 'mittal.gitika@gmail.com', :password => 'iamdbest', :password_confirmation => 'iamdbest')
  end
  
end
