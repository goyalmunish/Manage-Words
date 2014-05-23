class Flag < ActiveRecord::Base
  # associations

  # validations
  validates :name, presence: true, uniqueness: true, length: {maximum: 25}
  validates :desc, length: {maximum: 100}

  # callbacks

  # scopes
end
