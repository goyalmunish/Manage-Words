require 'common_model'
require 'my_dictionary'
class FlagsWord < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  include MyDictionary

  # ASSOCIATIONS
  belongs_to :flag
  belongs_to :word

  # CALLBACKS

  # VALIDATIONS

  # CUSTOM METHODS

  # SCOPES

  # ACCESS
end
