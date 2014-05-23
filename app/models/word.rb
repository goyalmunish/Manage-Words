class Word < ActiveRecord::Base
  # associations
  belongs_to :user

  # validations
  validates :word, presence: true, uniqueness: true, length: {maximum: 25}
  validates :trick, length: {maximum: 100}
  validates :user_id, presence: true
  validates :additional_info, length: {maximum: 2048}

  # callbacks

  # scopes

end
