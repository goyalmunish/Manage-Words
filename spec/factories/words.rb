# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :word do
    association :user
    word "MyString"
    trick "MyString"
    additional_info "MyString "
  end

  factory :word_1, class: Word do
    association :user, strategy: :build
    word "MyString_1"
    trick "MyString_1"
    additional_info "MyString_1 "
  end

  factory :word_without_user, class: Word do
    word "MyString"
    trick "MyString"
    additional_info "MyString "
  end
end
