require 'common_model'
class DictionariesUser < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models

  # ASSOCIATIONS
  belongs_to :dictionary
  belongs_to :user

  # CALLBACKS

  # VALIDATIONS

  # CUSTOM METHODS

  # SCOPES

  # ACCESS
end

