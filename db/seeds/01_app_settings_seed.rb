# USER NOTIFICATION
puts "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
puts '** Seeding AppSettings (if required) **'
puts '** Note: Pay heed to following messages **'
sleep(5.seconds.to_i)

# required libraries
require 'securerandom'

# # SEEDING APP SETTINGS # #
# Examples
# puts AppSetting.set_if_nil(key, value)
# puts AppSetting.set_if_nil(key, 'XXX')
# puts AppSetting.set_if_nil('os_currencies', JSON.generate(%w(USD CAD AUD EUR GBP INR)))
# puts AppSetting.set_if_nil('mailer_credentials', JSON.generate({'email1' => 'passpwd1', 'email2' => 'passwd2'}))

# Seeding flags
Flag.create!(name: 'comfort_level_3', desc: 'Highly Comfortable')
Flag.create!(name: 'comfort_level_2', desc: 'Comfortable')
Flag.create!(name: 'comfort_level_1', desc: 'Familiar')
Flag.create!(name: 'comfort_level_0', desc: 'To Learn')
Flag.create!(name: 'pronunciation', desc: 'Check Pronunciation')

#
# puts AppSetting.set_if_nil('facebook_app_id', 'XXX')
# puts AppSetting.set_if_nil('facebook_app_secret', 'XXX')
#
# puts AppSetting.set_if_nil('mailer_address', 'smtp.gmail.com')
# puts AppSetting.set_if_nil('mailer_port', '587')
# puts AppSetting.set_if_nil('mailer_domain', 'www.XXX.com')
# puts AppSetting.set_if_nil('mailer_user_name', 'XXX')
# puts AppSetting.set_if_nil('mailer_password', 'XXX')
# puts AppSetting.set_if_nil('mailer_authentication', 'plain')
# puts AppSetting.set_if_nil('mailer_enable_starttls_auto', 'true')
# puts AppSetting.set_if_nil('mailer_default_url_host', 'www.XXX.com')
# puts AppSetting.set_if_nil('mailer_raise_delivery_errors', 'false')
# puts AppSetting.set_if_nil('mailer_delivery_method', 'smtp')
#
# puts AppSetting.set_if_nil('devise_secret_key', SecureRandom.hex(128))
# puts "\n!!!!!!!!!!Note: devise_secret_key should never be changed.\n\n"
# 

# 


# LAST LINE: 
puts "\n"+'!!!!!!!!!!Check your app_settings table and look for nil and "XXX" values, and update them.'+"\n"
