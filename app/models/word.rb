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
  after_save :remove_similar_flags_with_lower_level

  # validations
  validates :word, presence: true, uniqueness: true, length: {maximum: 25}
  validates :trick, length: {maximum: 100}
  validates :additional_info, length: {maximum: 2048}

  # custom methods
  def remove_similar_flags_with_lower_level
    # finding required ids
    ids = Flag.flag_ids_with_available_max_level(self.flags)
    # deleting appropriate ids from association so that only required ids are present
    self.flag_ids = ids
  end

  # scopes
  default_scope ->{ order(:word => :asc) }
  scope :without_trick, ->{ where('trick IS NULL') }
end

