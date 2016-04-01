# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Jbuilder key format
Jbuilder.key_format ->(key){key.gsub('_', '-')}
