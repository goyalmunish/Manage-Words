require 'common_model'
class Flag < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  # associations
  has_and_belongs_to_many :word

  # callbacks
  before_validation :convert_blank_to_nil
  before_save :convert_blank_to_nil

  # validations
  validates :name, presence: true, uniqueness: true, length: {maximum: 25}
  validates :desc, length: {maximum: 100}


  # scopes
  default_scope ->{ order(:name => :asc) }
end

