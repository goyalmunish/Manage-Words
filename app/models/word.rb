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
      logger.info "Error: InCorrectArgument; WordCollectionClass: #{word_collection.class}"
    end
    # calculating associated number of flags
    words = Word.where(:id => relevant_ids).includes(:flags)
    num = 0
    words.each do |word|
      num += word.flags.size
    end
    return num
  end

  def promote_flag(flag_name, dir)
    # 'dir' is direction which can be 'up' or 'down'

    # logging
    logger.info "PromoteFlag request for Word: #{self.word}, for Flag: #{flag_name}, in Dir: #{dir}"

    # setting up required variables
    flag_name = flag_name.to_s  # making sure the 'flag_name' is in string form
    dir = dir.to_s.downcase  # making sure 'dir' is downcase
    flag_hash = Flag.flag_hash_with_sorted_array_values
    max_index = Flag.max_index_for_flag_name(flag_name)
    sorted_available_levels = flag_hash[flag_name.to_sym]

    # finding flag
    flag = self.flags.where(:name => flag_name).first

    # finding flag value
    if flag
      flag_value = flag.value # assuming there can't exist multiple associated flags with same name
    else
      flag_value = nil
    end

    # finding current and next index
    indices = Flag.current_and_next_index_for_flag_name_value_dir(
        :name => flag_name,
        :value => flag_value,
        :dir => dir
    )
    current_index = indices[:current_index]
    next_index = indices[:next_index]

    # replacing flag
    if next_index && (current_index != next_index)
      current_flag_id = current_index ? Flag.where(:name => flag_name, :value => flag_value).first.id : nil
      new_flag_id = Flag.where(:name => flag_name, :value => sorted_available_levels[next_index]).first.id
      ids = self.flag_ids
      ids.delete(current_flag_id)
      ids << new_flag_id
      logger.info 'PromoteFlag request processed'
      self.flag_ids = ids
    else
      logger.info 'PromoteFlag request COULD NOT BE processed'
    end
  end

  def self.search(database, search_text, search_type, search_negative=false)
    # search by default for word
    if search_type.blank?
      search_type = 'word'
    end
    # executing relevant query
    if search_text && !search_text.blank?
      if database == 'pg'
        if search_type == 'word'
          if search_negative
            search_word_pg_regex_not(search_text)
          else
            search_word_pg_regex(search_text)
          end
        elsif search_type == 'record'
          if search_negative
            search_full_pg_regex_not(search_text)
          else
            search_full_pg_regex(search_text)
          end
        end
      else
        if search_type == 'word'
          if search_negative
            search_word_text_not(search_text)
          else
            search_word_text(search_text)
          end
        elsif search_type == 'record'
          if search_negative
            search_full_text_not(search_text)
          else
            search_full_text(search_text)
          end
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
  scope :search_word_text_not, lambda { |search_text| where.not('word LIKE :text', :text => "%#{search_text}%") }
  scope :search_full_text, lambda { |search_text| where('word LIKE :text OR trick LIKE :text OR additional_info LIKE :text', :text => "%#{search_text}%") }
  scope :search_full_text_not, lambda { |search_text| where.not('word LIKE :text OR trick LIKE :text OR additional_info LIKE :text', :text => "%#{search_text}%") }
  scope :search_word_pg_regex, lambda { |search_text| where('word ~* :text', :text => search_text) } # Note: it works only in postgres
  scope :search_word_pg_regex_not, lambda { |search_text| where.not('word ~* :text', :text => search_text) } # Note: it works only in postgres
  scope :search_full_pg_regex, lambda { |search_text| where('word ~* :text OR trick ~* :text OR additional_info ~* :text', :text => search_text) } # Note: it works only in postgres
  scope :search_full_pg_regex_not, lambda { |search_text| where.not('word ~* :text OR trick ~* :text OR additional_info ~* :text', :text => search_text) } # Note: it works only in postgres

  protected
  # protected methods

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

end
