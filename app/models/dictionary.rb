class Dictionary < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models

  # associations
  has_and_belongs_to_many :users

  # callbacks
  before_validation :convert_blank_to_nil, :strip_string_fields

  # validations
  validates :name, presence: true, length: {maximum: 25}, uniqueness: true
  validates :url, presence: true, length: {maximum: 150}
  validates :separator, presence: true, length: {maximum: 5}
  validates :suffix, length: {maximum: 25}
  validates :additional_info, presence: false, length: {maximum: 250}

  # custom methods

  # scopes

end