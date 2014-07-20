class AppSetting < ActiveRecord::Base

  # CALLBACKS
  before_validation :underscore_the_key

  # VALIDATIONS
  validates :key, presence: true, uniqueness: true

  # CUSTOM SINGLETON METHODS
  # finds a record for the passed key, returns nil if doesn't exist
  def self.find_by_key(k)
    self.where(:key => k.underscore).first
  end

  # gets a record for passed key, returns nil if key doesn't exist or it's value is nil
  def self.get(k)
    if k.blank?
      raise 'NonBlankKeyRequired'
    end
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
        s = self.create!(:key => k, :value => v)
      end
      return s
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
    ":#{self.key} => '#{self.value}'"
  end


  # SCOPES

  protected

  def underscore_the_key
    unless key.blank?
      self.key = self.key.underscore
    end
  end
end
