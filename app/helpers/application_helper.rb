module ApplicationHelper
  def get_flag_hash
    Flag.flag_hash
  end

  def get_flag(name, value)
    name = name.to_s
    value = value.to_i
    Flag.where(:name => name, :value => value).first
  end

  def flags_name_value_array(word_id)
    word = Word.find(word_id)
    name_value_array = word.flags.order(:name => :asc, :value => :desc).map do |flag|
      "#{flag.name}-#{flag.value}"
    end
  end
end
