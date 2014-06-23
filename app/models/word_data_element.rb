class WordDataElement
  attr_reader :word, :trick, :additional_info
  attr_accessor :flags_attributes

  def initialize(word, trick, additional_info, flags_attributes = Array.new)
    @word = word
    @trick = trick
    @additional_info = additional_info
    @flags_attributes = flags_attributes
  end

  def append_to_flags_attributes(name, value)
    self.flags_attributes << {:name => name, :value => value}
  end

  def to_h
    {:word => word, :trick => trick, :additional_info => additional_info, :flags_attributes => flags_attributes}
  end

  # for backup
  def self.word_data_backup(words = Word.includes(:flags).all)
    word_data_elements = Array.new
    words.each do |word|
      temp_word_data_element = WordDataElement.new(word.word, word.trick, word.additional_info)
      word.flags.each do |flag|
        temp_word_data_element.append_to_flags_attributes(flag.name, flag.value)
      end
      word_data_elements << temp_word_data_element.to_h
    end
    Rails.logger.info "Data Backup for #{words.count} words"
    return word_data_elements
  end

  # for backup restore
  def self.restore_word_data_backup(user_id, array_data)
    user = User.find(user_id)
    word_count = 0
    array_data.each do |hash_data|
      # extracting flag_attributes
      flags_attributes = hash_data['flags_attributes']
      hash_data.except!('flags_attributes')
      # saving word and its flag associations
      Rails.logger.info "Start Backup: #{hash_data['word']}"
      ActiveRecord::Base.transaction do
        word = user.words.create(hash_data)
        if word && word.id
          Rails.logger.info "\tDONE WORD"
          word_count += 1
          # now associating flags
          flags_attributes.each do |flag_hash|
            flag = Flag.where(flag_hash).first
            if flag
              word.flags << flag
            end
          end
        end
      end
    end
    Rails.logger.info "Restored #{word_count} words for user_id #{user_id}\n"
    return word_count
  end
end