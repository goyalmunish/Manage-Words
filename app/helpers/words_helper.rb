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
    name << "MAX-UPDATED-AT-#{Word.maximum(:updated_at).try(:getutc)}".split.join("_")
    if filters_and_orders[:sort_by] == 'random'
      # cached fragment should not be used in case of random sorting
      name << "RANDOM-AT-#{Time.now.to_s}"
    end
    return_value = name.join('__')
    Rails.logger.info "Cache Name: #{return_value}"
    return return_value
  end

  def word_fragment_name(user_id, word)
    name = Array.new
    name << "USERID-#{user_id}"
    name << "WORDID-#{word.id}"
    name << "FLAGIDS-#{word.flag_ids.inspect}"
    name << "WORD-UPDATED-AT-#{word.updated_at.try(:getutc)}".split.join("_")
    return_value = name.join('__')
    Rails.logger.info "Cache Name: #{return_value}"
    return return_value
  end
end
