require 'common_model'
require 'my_dictionary'
class DictionariesUser < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  include MyDictionary

  # ASSOCIATIONS
  belongs_to :dictionary
  belongs_to :user

  # CALLBACKS

  # VALIDATIONS

  # CUSTOM METHODS

  # SCOPES

  # ACCESS
end
