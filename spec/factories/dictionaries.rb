# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dictionary do
    name "dict_name"
    url "dic_url"
    separator "-"
    suffix "some_suffix"
    additional_info "MyString"
  end
end
