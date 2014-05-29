module CommonModel
  def self.included(base)
    base.extend(ClassMethods);
  end

  module ClassMethods
    # module class methods will be kept here 
  end

  # called before validation, create and save all 
  # it converts blank values (usually we get blank values from registration forms) to nil
  # NOTE THAT IT WILL CREATE ISSUES WITH BOOLEAN FIELDS WITH FALSE VALUE
  def convert_blank_to_nil
    all_fields = self.get_array_of_symbolic_keys
    # updating record's field with nil for blank values 
    all_fields.each do |field|
      if self[field].blank?
        self[field] = nil;
      end
    end
  end

  # it removes leading or trailing whitespaces
  def strip_string_fields
    all_fields = self.get_array_of_symbolic_keys
    # stripping
    all_fields.each do |field|
      unless self[field].nil?
        if self[field].class == String
          self[field] = self[field].strip
        end
      end
    end
  end

  # getting array of all symbolic keys
  def get_array_of_symbolic_keys
    # getting array of keys (in symbol form)
    all_fields = self.attributes.keys.map do |key|
      key.to_sym;
    end
    return all_fields
  end

end
