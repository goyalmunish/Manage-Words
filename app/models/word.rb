require 'common_model'
require 'my_dictionary'
class Word < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  include MyDictionary
  # associations
  belongs_to :user
  has_and_belongs_to_many :flags

  # callbacks
  before_validation :convert_blank_to_nil
  before_save :convert_blank_to_nil

  # validations
  validates :word, presence: true, uniqueness: true, length: {maximum: 25}
  validates :trick, length: {maximum: 100}
  validates :additional_info, length: {maximum: 2048}

  # custom methods

  # scopes
  default_scope ->{ order(:word => :asc) }
  scope :to_work_upon, ->{ where('trick IS NULL') }
end

