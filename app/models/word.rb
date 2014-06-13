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
  validates :user_id , presence: true
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
      # saving word
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
      relevant_ids =  word_collection.id
    else
      raise 'IncorrectArguments'
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

  # SCOPES
  default_scope -> { order(:word => :asc) }
  scope :without_trick, -> { where('trick IS NULL') }
  scope :with_trick, -> { where('trick IS NOT NULL') }
  scope :with_flag_id, lambda { |flag_id| joins(:flags).merge(Flag.with_flag_id(flag_id)) }
  scope :with_flag_id2, lambda { |flag_id| where("flags.id" => flag_id) } # for test
  scope :without_flag, -> { includes(:flags).where("flags.id IS NULL").references(:flags) }

  # ACCESS
  protected :down_case_word, :remove_similar_flags_with_lower_level
end

