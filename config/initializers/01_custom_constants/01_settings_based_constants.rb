# Note: initializers files are loaded in alphabetical order
# Note: the '01_' in name of directory '01_custom_constants' makes it to be loadable earlier than other constants
# Note: the loading of '01_custom_constants' at the earliest is required (except before 00_active_admin.rb), as these values are used in other initializer files


#### WORKAROUND ###################################
# note that as we are referencing AppSetting class, it has to exist before running this
# otherwise it will create problem if you try to run "rake db:migrate" on newly created database
begin
  AppSetting.first
rescue => ex
  class AppSetting < ActiveRecord::Base
    def self.get(str)
      nil
    end
  end
end


#### DEFINING CONSTANTS ###########################

# SITE NAME
SITE_NAME = AppSetting.get('site_name')
SITE_URL = AppSetting.get('site_url')
EMAIL_CUSTOMER_CARE = AppSetting.get('email_customer_care')

# TITLES
TITLE_SITE_HOME = AppSetting.get('title_site_home')
TITLE_REGISTER = AppSetting.get('title_register')
TITLE_LOGIN = AppSetting.get('title_login')
TITLE_LOGOUT = AppSetting.get('title_logout')
TITLE_ABOUT_US = AppSetting.get('title_about_us')
TITLE_CONTACT_US = AppSetting.get('title_contact_us')
TITLE_HELP = AppSetting.get('title_help')
TITLE_FAQS = AppSetting.get('title_faqs')

# ACTIVE ADMIN
# url: /aadmin
# Note: default aadmin id and password is set in *_devise_create_admin_users.rb migration file
# AADMIN_ID = AppSetting.get('aadmin_id')
# AADMIN_PWD = AppSetting.get('aadmin_pwd')

# FACEBOOK SETTINGS
# FACEBOOK_APP_ID = AppSetting.get('facebook_app_id')
# FACEBOOK_APP_SECRET = AppSetting.get('facebook_app_secret')

# DEVISE SETTINGS
DEVISE_SECRET_KEY = AppSetting.get('devise_secret_key') || 'Change devise_secret_key'

# MAILER
# MAILER_ADDRESS = AppSetting.get('mailer_address')
# MAILER_PORT = AppSetting.get('mailer_port').to_i
# MAILER_DOMAIN = AppSetting.get('mailer_domain')
# MAILER_USER_NAME = AppSetting.get('mailer_user_name')
# MAILER_PASSWORD = AppSetting.get('mailer_password')
# MAILER_AUTHENTICATION = AppSetting.get('mailer_authentication')
# MAILER_ENABLE_STARTTLS_AUTO = eval("#{AppSetting.get('mailer_enable_starttls_auto')}")
# MAILER_DEFAULT_URL_HOST = AppSetting.get('mailer_default_url_host')
# MAILER_RAISE_DELIVERY_ERRORS = eval("#{AppSetting.get('mailer_raise_delivery_errors')}")
# MAILER_DELIVERY_METHOD = "#{AppSetting.get('mailer_delivery_method')}".to_sym
# MAILER_CREDENTIALS = (AppSetting.get('mailer_credentials') ? JSON.parse(AppSetting.get('mailer_credentials')) : nil)

# some numeric constants
# SESSION_TIMEOUT_DURATION = AppSetting.get('session_timeout_duration').to_i # minutes



