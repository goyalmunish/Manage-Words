class DataElement
  attr_reader :email, :words

  def initialize(args)
    args = defaults.merge(args)
    @email = args[:email]
    @words = args[:words]
  end

  def to_h
    {:email => email, :words => words}
  end

  def append_to_words(word_data_element)
    self.words << word_data_element
  end

  # for backup
  # knows User instance, its relation with Word, Word instance, its relation with Flag, and Flag instance
  def self.data_backup(users = self.all_users_with_eager_loaded_words_and_flags_wrapper)
    data_elements = Array.new
    users.each do |user|
      data_elements << DataElement.new(
          :email => user.email,
          :words => WordDataElement.word_data_backup(user.words.includes(:flags)))
    end
    return data_elements
  end

  # for backup restore
  def self.restore_data_backup(array_data)
    word_count = 0
    array_data.each do |hash_data|
      user = self.get_user_from_email_wrapper(hash_data['email'])
      if user
        temp_count = self.restore_word_data_backup_for_user_wrapper(
            :user => user,
            :array_data => hash_data['words'])
        word_count += temp_count
      end
    end
    return word_count
  end

  protected

  attr_writer :words

  def defaults
    {:words => Array.new}
  end

  # wrapper for external dependencies
  def self.all_users_with_eager_loaded_words_and_flags_wrapper
    User.includes(:words => :flags).all
  end

  # wrapper for external dependencies
  def self.get_user_from_email_wrapper(email)
    user = User.where(:email => email).first
  end

  # wrapper for external dependencies
  def self.restore_word_data_backup_for_user_wrapper(args)
    user = args[:user]
    array_data = args[:array_data]
    count = WordDataElement.restore_word_data_backup(
        :user => user,
        :array_data => array_data)
    return count
  end

end
