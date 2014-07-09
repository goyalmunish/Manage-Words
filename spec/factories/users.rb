# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "MyString"
    last_name "MyString"
    type ""
    email "my_email@host.com"
    password "some_password"
    password_confirmation "some_password"

    factory :admin_user do
      type "Admin"
    end
  end

  factory :user_1 do
    first_name "MyString_1"
    last_name "MyString_1"
    type ""
    email "my_email_1@host.com"
    password "some_password_1"
    password_confirmation "some_password_1"
  end
end
