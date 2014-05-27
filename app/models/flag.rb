require 'common_model'
class Flag < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  # associations
  has_and_belongs_to_many :words

  # callbacks
  before_validation :convert_blank_to_nil
  before_save :convert_blank_to_nil

  # validations
  validates :name, presence: true, uniqueness: {scope: [:value]}, length: {maximum: 5}
  validates :value, presence: true, numericality: :only_integer
  validates :desc, length: {maximum: 100}

  # custom methods
  def self.flag_hash(flags = Flag.all)
    flag_hash = Hash.new
    flags.each do |flag|
      flag_hash[flag.name.to_sym] ||= Array.new
      flag_hash[flag.name.to_sym] << flag.value
    end
    return flag_hash
  end

  # scopes
  default_scope ->{ order(:name => :asc, :value => :desc) }
end

