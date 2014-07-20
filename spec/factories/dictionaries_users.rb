# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dictionaries_user do
    association :dictionary
    association :user
  end
end
