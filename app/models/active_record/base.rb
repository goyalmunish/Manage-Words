require 'common_model'
module ActiveRecord
  class ActiveRecord::Base
    include CommonModel # custom library placed in lib directory, containing methods common to all models

    # callbacks
    before_validation :convert_blank_to_nil
    before_save :convert_blank_to_nil

  end
end
