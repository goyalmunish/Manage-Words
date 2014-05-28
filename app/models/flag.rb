require 'common_model'
class Flag < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  # associations
  has_and_belongs_to_many :words

  # callbacks
  before_validation :convert_blank_to_nil, :strip_name_and_desc
  before_save :convert_blank_to_nil, :strip_name_and_desc

  # validations
  validates :name, presence: true, uniqueness: {scope: [:value]}, length: {maximum: 5}
  validates :value, presence: true, numericality: :only_integer
  validates :desc, length: {maximum: 100}

  # custom methods
  def strip_name_and_desc
    self.name.strip! if self.name
    self.desc.strip! if self.desc
  end

  def self.flag_hash(flags = Flag.all)
    flag_hash = Hash.new
    flags.each do |flag|
      flag_hash[flag.name.to_sym] ||= Array.new
      flag_hash[flag.name.to_sym] << flag.value
    end
    return flag_hash
  end

  def self.flag_ids_with_available_max_level(flags = Flag.all)
    flag_hash = self.flag_hash(flags)
    ids = Array.new
    flag_hash.each do |key, values|
      ids << Flag.where(:name => key.to_s, :value => values.max).first.id
    end
    return ids
  end

  # scopes
  default_scope ->{ order(:name => :asc, :value => :desc) }
end
