class WordDataElement
  attr_reader :word, :trick, :additional_info, :flags_attributes

  def initialize(args)
    args = defaults.merge(args)
    @word = args[:word]
    @trick = args[:trick]
    @additional_info = args[:additional_info]
    @flags_attributes = args[:flags_attributes]
  end

  def to_h
    {:word => word, :trick => trick, :additional_info => additional_info, :flags_attributes => flags_attributes}
  end

  def append_to_flags_attributes(args)
    self.flags_attributes << args.select{ |key, value| [:name, :value].include? key}
  end

  # for backup
  # knows about Word instances, its relation with Flag, and Flag instance
  def self.word_data_backup(words = self.all_words_with_eager_loaded_flags_wrapper)
    word_data_elements = Array.new
    words.each do |word|
      temp_word_data_element = WordDataElement.new(
          :word => word.word,
          :trick => word.trick,
          :additional_info => word.additional_info)
      word.flags.each do |flag|
        temp_word_data_element.append_to_flags_attributes(:name => flag.name, :value => flag.value)
      end
      word_data_elements << temp_word_data_element.to_h
    end
    Rails.logger.info "Data Backup for #{words.count} words"
    return word_data_elements
  end

  # for backup restore
  # knows User instance, its relation with Word, Word instance, its relation with Flag
  def self.restore_word_data_backup(args)
    user = args[:user]
    array_data = args[:array_data]
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
    Rails.logger.info "Restored #{word_count} words for email #{user.email}\n"
    return word_count
  end

  protected

  attr_writer :flags_attributes

  def defaults
    {:flags_attributes => Array.new}
  end

  # wrapper for external dependencies
  def self.all_words_with_eager_loaded_flags_wrapper
    Word.includes(:flags).all
  end

end
