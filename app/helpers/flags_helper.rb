module FlagsHelper
  def flag_name_and_value(flag)
    "#{flag.name}-#{flag.value}"
  end

  def flag_name_value_and_desc(flag)
    "#{flag.name}-#{flag.value} | #{flag.desc}"
  end
end

