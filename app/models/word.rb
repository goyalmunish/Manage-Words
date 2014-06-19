require 'common_model'
require 'my_dictionary'
class Word < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  include MyDictionary

  # ASSOCIATIONS
  belongs_to :user
  # has_and_belongs_to_many :flags
  has_many :flags_words
  has_many :flags, through: :flags_words

  # CALLBACKS
  before_validation :convert_blank_to_nil, :strip_string_fields
  before_validation :down_case_word
  after_save :remove_similar_flags_with_lower_level

  # VALIDATIONS
  validates :user_id, presence: true
  validates :word, presence: true, uniqueness: {scope: :user_id}, length: {maximum: 25}
  validates :trick, length: {maximum: 100}
  validates :additional_info, length: {maximum: 2048}

  # CUSTOM METHODS
  def self.touch_latest_updated_at_word_record_for_user(user)
    last_updated_record = user.words.reorder(:updated_at => :desc).first
    last_updated_record.touch
  end

  # for backup
  # Note: the 'restore_backup' method depends on JSON format created by this method
  def self.data_backup(words = Word.all)
    data = Array.new
    words.each do |word|
      temp_hash = {
          :word => word.word,
          :trick => word.trick,
          :additional_info => word.additional_info,
          :flags_attributes => Array.new}
      word.flags.each do |flag|
        temp_hash[:flags_attributes] << {:name => flag.name, :value => flag.value}
      end
      data << temp_hash
    end
    return data
  end

  # for backup restore from given JSON file
  # Note: format of given backup file should be same as generated backup file
  def self.restore_backup(user_id, array_data)
    user = User.find(user_id)
    count = 0
    array_data.each do |hash_data|
      # extracting flag_attributes
      flags_attributes = hash_data['flags_attributes']
      hash_data.except!('flags_attributes')
      # saving word and its flag associations
      ActiveRecord::Base.transaction do
        word = user.words.create(hash_data)
        if word && word.id
          count += 1
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
    return count
  end

  # it returns number of associated flags for given passed word collection 
  def self.number_of_flag_associations(word_collection)
    # checking nature of the collection
    if [Word::ActiveRecord_Associations_CollectionProxy, Word::ActiveRecord_Relation, Word::ActiveRecord_AssociationRelation].include?(word_collection.class)
      relevant_ids = word_collection.pluck(:id)
    elsif word_collection.class == Array
      relevant_ids = word_collection.map { |word| word.id }
    elsif word_collection.class == Word
      relevant_ids = word_collection.id
    else
      raise "InCorrectArgument; WordCollectionClass: #{word_collection.class}"
    end
    # calculating associated number of flags
    words = Word.where(:id => relevant_ids).includes(:flags)
    num = 0
    words.each do |word|
      num += word.flags.size
    end
    return num
  end

  def remove_similar_flags_with_lower_level
    # finding required ids
    ids = Flag.flag_ids_with_available_max_level(self.flags)
    # deleting appropriate ids from association so that only required ids are present
    # records will automatically be handled in JOIN table
    self.flag_ids = ids
  end

  def down_case_word
    self.word = self.word.downcase
  end

  def promote_flag(flag_name, dir)
    # 'dir' is direction which can be 'up' or 'down'

    # finding current index
    flag_name = flag_name.to_s  # making sure the 'flag_name' is in string form
    dir = dir.to_s.downcase  # making sure 'dir' is downcase
    flag_hash = Flag.flag_hash
    unless flag_hash.has_key?(flag_name.to_sym)
      raise "IncorrectFlag:#{flag_name.to_s}"
    end
    sorted_available_levels = flag_hash[flag_name.to_sym].sort
    max_index = sorted_available_levels.size - 1
    flag = self.flags.where(:name => flag_name).first
    if flag
      flag_value = flag.value # assuming there can't exist multiple associated flags with same name
      current_index = sorted_available_levels.index(flag_value)
    else
      flag_value = nil
      current_index = nil
    end

    # finding new index
    if current_index
      new_index = current_index
      case dir
        when 'up'
          new_index += 1 if new_index < max_index
        when 'down'
          new_index -= 1 if new_index > 0
        else
          raise "IncorrectDirection:#{dir}"
      end
    else
      case dir
        when 'up'
          new_index = 0
        when 'down'
          # incorrect user input
          return nil
      end
    end

    # replacing flag
    unless current_index == new_index
      current_flag_id = current_index ? Flag.where(:name => flag_name, :value => flag_value).first.id : nil
      new_flag_id = Flag.where(:name => flag_name, :value => sorted_available_levels[new_index]).first.id
      ids = self.flag_ids
      ids.delete(current_flag_id)
      ids << new_flag_id
      self.flag_ids = ids
    end
  end

  def self.search(database, search_text, search_type)
    # search by default for word
    if search_type.blank?
      search_type = 'word'
    end
    # executing relevant query
    if search_text && !search_text.blank?
      if database == 'pg'
        if search_type == 'word'
          search_word_pg_regex(search_text)
        elsif search_type == 'record'
          search_full_pg_regex(search_text)
        end
      else
        if search_type == 'word'
          search_word_text(search_text)
        elsif search_type == 'record'
          search_full_text(search_text)
        end
      end
    else
      all # returning a chainable relation
    end
  end

  # SCOPES
  default_scope -> { order(:word => :asc) }
  scope :without_trick, -> { where('trick IS NULL') }
  scope :with_trick, -> { where('trick IS NOT NULL') }
  scope :with_flag_id, lambda { |flag_id| joins(:flags).merge(Flag.with_flag_id(flag_id)) }
  scope :with_flag_id2, lambda { |flag_id| where("flags.id" => flag_id) } # FOR TEST (NOT IN USE)
  scope :without_flag, -> { includes(:flags).where("flags.id IS NULL").references(:flags) }
  scope :search_word_text, lambda { |search_text| where('word LIKE :text', :text => "%#{search_text}%") }
  scope :search_full_text, lambda { |search_text| where('word LIKE :text OR trick LIKE :text OR additional_info LIKE :text', :text => "%#{search_text}%") }
  scope :search_word_pg_regex, lambda { |search_text| where('word ~* :text', :text => search_text) } # Note: it works only in postgres
  scope :search_full_pg_regex, lambda { |search_text| where('word ~* :text OR trick ~* :text OR additional_info ~* :text', :text => search_text) } # Note: it works only in postgres

  # ACCESS
  protected :down_case_word, :remove_similar_flags_with_lower_level
end

