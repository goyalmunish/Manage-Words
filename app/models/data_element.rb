class DataElement
  attr_reader :email
  attr_accessor :words

  def initialize(email, words = Array.new())
    @email = email
    @words = words
  end

  def append_to_words(word_data_element)
    self.words << word_data_element
  end

  def to_h
    {:email => email, :words => words}
  end

  # for backup
  def self.data_backup(users = User.includes(:words => :flags).all)
    data_elements = Array.new
    users.each do |user|
      data_elements << DataElement.new(user.email, WordDataElement.word_data_backup(user.words.includes(:flags)))
    end
    return data_elements
  end

  # for backup restore
  def self.restore_data_backup(array_data)
    word_count = 0
    array_data.each do |hash_data|
      user = User.where(:email => hash_data['email']).first
      if user
        temp_count = WordDataElement.restore_word_data_backup(user.id, hash_data['words'])
        word_count += temp_count
      end
    end
    return word_count
  end
end
