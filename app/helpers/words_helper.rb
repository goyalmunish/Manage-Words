module WordsHelper
  def flags_name_value_array(word)
    name_value_array = word.flags.map do |flag|
      "#{flag.name}-#{flag.value}"
    end
    name_value_array.sort
  end

  def words_index_fragment_name(user_id, filters_and_orders)
    name = Array.new
    name << "USERID-#{user_id}"
    name << "FILTERS-AND-ORDERS-#{filters_and_orders.inspect}"
    name << "COUNT-#{Word.count}"
    name << "MAX-UPDATED-AT-#{Word.maximum(:updated_at).try(:getutc)}"
    return name.join('__')
  end
end
