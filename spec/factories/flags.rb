# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flag do
    name "MyString"
    value 0
    desc "MyString"
  end

  factory :flag_1, class: Flag do
    name "MyString_1"
    value 1
    desc "MyString_1"
  end

  factory :flag_cl, class: Flag do
    name "CL"
    desc "Flag CL"
    factory :flag_cl_0 do
      value 0
    end
    factory :flag_cl_1 do
      value 1
    end
    factory :flag_cl_2 do
      value 2
    end
    factory :flag_cl_3 do
      value 3
    end
    factory :flag_cl_4 do
      value 4
    end
  end

  factory :flag_cp, class: Flag do
    name "CP"
    desc "Flag CP"
    factory :flag_cp_0 do
      value 0
    end
    factory :flag_cp_1 do
      value 1
    end
    factory :flag_cp_2 do
      value 2
    end
    factory :flag_cp_3 do
      value 3
    end
    factory :flag_cp_4 do
      value 4
    end
  end

  factory :flag_k, class: Flag do
    name "K"
    desc "Flag K"
    factory :flag_k_0 do
      value 0
    end
    factory :flag_k_1 do
      value 1
    end
    factory :flag_k_2 do
      value 2
    end
    factory :flag_k_3 do
      value 3
    end
    factory :flag_k_4 do
      value 4
    end
  end
end

