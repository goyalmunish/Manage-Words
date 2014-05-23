class AppSetting < ActiveRecord::Base

  # CUSTOM SINGLETON METHODS
  # finds a record for the passed key, returns nil if doesn't exist
  def self.find_by_key(k)
    self.where(:key => k).first
  end

  # gets a record for passed key, returns nil if key doesn't exist or it's value is nil
  def self.get(k)
    record = self.find_by_key(k)
    if record
      record.value
    else
      nil
    end
  end

  # updates or creates the given key with given value
  def self.set(k, v)
    if k.blank?
      raise 'NonBlankKeyRequired'
    else
      s = self.find_by_key(k)
      if s
        s.value = v
        s.save!
      else
        # lower_case the key and create
        self.create!(:key => k.downcase, :value => v)
      end
    end
  end

  # it sets the value if key doesn't exist or is set to nil
  def self.set_if_nil(k, v)
    if self.get(k)
      # don't update
      nil
    else
      # update nil value to given value or create key with given value
      self.set(k, v)
    end
  end

  # sets a key (if present) to nil value
  def self.unset(k)
    if self.get(k)
      self.set(k, nil)
    else
      # do nothing as either key doesn't exist or it is set to nil
    end
  end

  # CUSTOM INSTANCE METHODS
  def to_s
    if self.value.nil?
      ":#{self.key} IS NIL"
    else
      ":#{self.key} => '#{self.value}'"
    end
  end


  # CUSTOM SCOPES


  # attr_accessible :key, :value
end
