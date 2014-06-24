require 'common_model'
class Flag < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  # ASSOCIATIONS
  # has_and_belongs_to_many :words
  has_many :flags_words
  has_many :words, through: :flags_words

  # CALLBACKS
  before_validation :convert_blank_to_nil, :strip_string_fields

  # VALIDATIONS
  validates :name, presence: true, uniqueness: {scope: [:value]}, length: {maximum: 5}
  validates :value, presence: true, numericality: :only_integer
  validates :desc, length: {maximum: 100}

  # CUSTOM METHODS
  # it DRIes up given flags hash and makes it more understandable to humans and programs
  # example {:CL=>[0, 1, 2, 5], :CP=>[1]}
  def self.flag_hash_with_sorted_array_values(flags = Flag.all)
    # creating hash with unsorted values
    flag_hash = Hash.new
    flags.each do |flag|
      flag_hash[flag.name.to_sym] ||= Array.new
      flag_hash[flag.name.to_sym] << flag.value
    end
    # sorting value hash
    flag_hash.each {|key, value| value.sort!}
    return flag_hash
  end

  # raises error is flag_name is not valid
  def self.is_flag_name_valid(flag_name)
    flag_hash = Flag.flag_hash_with_sorted_array_values
    unless flag_hash.has_key?(flag_name.to_sym)
      raise "IncorrectFlag:#{flag_name.to_s}"
    end
    return true
  end

  # index is based on return value of flag_hash_with_sorted_array_values
  def self.max_index_for_flag_name(flag_name)
    # making sure flag_name exists
    is_flag_name_valid(flag_name)
    # finding max index for given flag_name
    flag_hash = Flag.flag_hash_with_sorted_array_values
    max_index = flag_hash[flag_name.to_s.to_sym].size - 1
  end

  # index is based on return value of flag_hash_with_sorted_array_values
  def self.current_index_for_flag(flag)
    flag_hash = Flag.flag_hash_with_sorted_array_values
    current_index = flag_hash[flag.name.to_sym].index(flag.value)
  end

  # index is based on return value of flag_hash_with_sorted_array_values
  # raises error for incorrect programming input
  # returns nil for incorrect user input
  def self.current_and_next_index_for_flag_name_value_dir(args)
    # 'dir' can be 'up', or 'down'
    flag_name = args[:name].to_s
    flag_value = args[:value]
    dir = args[:dir].to_s.downcase

    # making sure flag_name exists
    is_flag_name_valid(flag_name)

    # finding flag and validating flag_value
    if flag_value
      flag = Flag.where(:name => flag_name, :value => flag_value).first
      unless flag
        raise "Flag with name #{flag_name} and value #{flag_value} could not be found"
      end
    else
      # flag_value is nil
      # so next index is 0 for 'up', and incorrect user input in case of 'down'
    end

    # finding current index
    if flag
      current_index = Flag.current_index_for_flag(flag)
    else
      current_index = nil
    end

    # finding new index
    max_index = Flag.max_index_for_flag_name(flag_name)
    if current_index
      next_index = current_index
      case dir
        when 'up'
          next_index += 1 if next_index < max_index
        when 'down'
          next_index -= 1 if next_index > 0
        else
          raise "IncorrectDirection:#{dir}"
      end
    else
      case dir
        when 'up'
          next_index = 0
        when 'down'
          # flag can't be downgraded further
          next_index = nil
      end
    end
    return_value = {:current_index => current_index, :next_index => next_index}
    logger.info return_value.inspect
    return return_value
  end

  # returns array of only relevant flag ids
  def self.flag_ids_with_available_max_level(flags = Flag.all)
    flag_hash = self.flag_hash_with_sorted_array_values(flags)
    ids = Array.new
    flag_hash.each do |key, values|
      ids << Flag.where(:name => key.to_s, :value => values.max).first.id
    end
    return ids
  end

  # it return name and value of the flag
  def flag_name_and_value
    "#{self.name}-#{self.value}"
  end

  # SCOPES
  default_scope -> { order(:name => :asc, :value => :desc) }
  scope :with_flag_id, lambda { |id| where(:id => id.to_i) }

  # ACCESS
end
