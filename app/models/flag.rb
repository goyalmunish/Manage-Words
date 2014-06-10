require 'common_model'
class Flag < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  # ASSOCIATIONS
  has_and_belongs_to_many :words

  # CALLBACKS
  before_validation :convert_blank_to_nil, :strip_string_fields

  # VALIDATIONS
  validates :name, presence: true, uniqueness: {scope: [:value]}, length: {maximum: 5}
  validates :value, presence: true, numericality: :only_integer
  validates :desc, length: {maximum: 100}

  # CUSTOM METHODS
  # it DRIes up given flags hash and makes it more understandable to humans and programs
  # example {:CL=>[3, 2, 1, 0], :CP=>[1]}
  def self.flag_hash(flags = Flag.all)
    flag_hash = Hash.new
    flags.each do |flag|
      flag_hash[flag.name.to_sym] ||= Array.new
      flag_hash[flag.name.to_sym] << flag.value
    end
    return flag_hash
  end

  # returns array of only relevant flag ids
  def self.flag_ids_with_available_max_level(flags = Flag.all)
    flag_hash = self.flag_hash(flags)
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
  default_scope ->{ order(:name => :asc, :value => :desc) }
  scope :with_flag_id, lambda { |id| where(:id => id.to_i) }

  # ACCESS
end
