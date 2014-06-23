class DataElement
  attr_reader :email, :words

  def initialize(args)
    args = defaults.merge(args)
    @email = args[:email]
    @words = args[:words]
  end

  def defaults
    {:words => Array.new}
  end

  def to_h
    {:email => email, :words => words}
  end

  def append_to_words(word_data_element)
    self.words << word_data_element
  end

  # has external dependencies
  def self.all_users_with_eager_loaded_words_and_flags
    User.includes(:words => :flags).all
  end

  # for backup
  # expects passed users argument to respond to words
  # expects each word to respond to flags
  # uses WordDataElement class directly
  def self.data_backup(users = self.all_users_with_eager_loaded_words_and_flags)
    data_elements = Array.new
    users.each do |user|
      data_elements << DataElement.new(
          :email => user.email,
          :words => WordDataElement.word_data_backup(user.words.includes(:flags)))
    end
    return data_elements
  end

  # for backup restore
  # uses User class directly
  # uses WordDataElement class directly
  def self.restore_data_backup(array_data)
    word_count = 0
    array_data.each do |hash_data|
      user = User.where(:email => hash_data['email']).first
      if user
        temp_count = WordDataElement.restore_word_data_backup(user, hash_data['words'])
        word_count += temp_count
      end
    end
    return word_count
  end

  protected

  attr_writer :words
end
