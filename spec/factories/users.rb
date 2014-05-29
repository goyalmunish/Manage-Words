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
end
