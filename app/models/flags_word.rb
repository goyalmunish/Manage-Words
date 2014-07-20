require 'common_model'
class FlagsWord < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models

  # ASSOCIATIONS
  belongs_to :flag
  belongs_to :word, touch: true

  # CALLBACKS

  # VALIDATIONS

  # CUSTOM METHODS

  # SCOPES

  # ACCESS
end

