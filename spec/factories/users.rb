# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "MyString"
    last_name "MyString"
    type ""
    provider "MyString"
    uid "MyString"
    additional_info "MyString"
  end
end
