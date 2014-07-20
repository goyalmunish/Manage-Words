# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flags_word do
    association :flag
    association :word
  end
end
