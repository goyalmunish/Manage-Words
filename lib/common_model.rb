module CommonModel
  def self.included(base)
    base.extend(ClassMethods);
  end

  module ClassMethods
    # module class methods will be kept here 
  end

  # called before validation, create and save all 
  # it converts blank values (usually we get blank values from registration forms) to nil
  # NOTE THAT IT WILL CREATE ISSUES WITH BOOLEAN FILEDS WITH FALSE VALUE 
  def convert_blank_to_nil
    # getting array of keys (in symbol form) 
    all_fields = self.attributes.keys.map do |key|
      key.to_sym;
    end
    # updating record's field with nil for blank values 
    all_fields.each do |field|
      if self[field].blank?
        self[field] = nil;
      end
    end
  end

end
