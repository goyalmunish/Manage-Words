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

  # index is based on return value of flag_hash_with_sorted_array_values
  def self.current_index_for_flag(flag)
    flag_hash = Flag.flag_hash_with_sorted_array_values
    current_index = flag_hash[flag.name.to_sym].index(flag.value)
  end

  # index is based on return value of flag_hash_with_sorted_array_values
  def self.max_index_for_flag_name(flag_name)
    flag_hash = Flag.flag_hash_with_sorted_array_values
    # making sure flag_name exists
    unless flag_hash.has_key?(flag_name.to_sym)
      raise "IncorrectFlag:#{flag_name.to_s}"
    end
    # finding max index for given flag_name
    max_index = flag_hash[flag_name.to_s.to_sym].size - 1
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
