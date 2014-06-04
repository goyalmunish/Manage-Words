module FlagsHelper
  def flag_name_and_value(flag)
    "#{flag.name}-#{flag.value}"
  end

  def flag_name_value_and_desc(flag)
    "#{flag.name}-#{flag.value} | #{flag.desc}"
  end

  def flags_index_fragment_name
    name = Array.new
    name << "COUNT-#{Flag.count}"
    name << "MAX-UPDATED-AT-#{Flag.maximum(:updated_at).try(:getutc)}"
    return name.join('__')
  end
end
