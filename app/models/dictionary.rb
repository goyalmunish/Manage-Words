class Dictionary < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models

  # ASSOCIATIONS
  # has_and_belongs_to_many :users
  has_many :dictionaries_users
  has_many :users, through: :dictionaries_users
  # CALLBACKS
  before_validation :convert_blank_to_nil, :strip_string_fields

  # VALIDATIONS
  validates :name, presence: true, length: {maximum: 25}, uniqueness: true
  validates :url, presence: true, length: {maximum: 150}
  validates :separator, presence: true, length: {maximum: 5}
  validates :suffix, length: {maximum: 25}
  validates :additional_info, presence: false, length: {maximum: 250}

  # CUSTOM METHODS
  def url_for_phrase(phrase)
    "#{self.url}#{phrase.split.join(self.separator)}#{self.suffix}"
  end

  def humanized_name
    self.name.titleize
  end

  # SCOPES
  default_scope -> { order(:id => :asc) }
end
