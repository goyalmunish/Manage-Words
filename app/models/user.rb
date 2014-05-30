require 'common_model'
class User < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models

  # include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # constants

  # associations
  has_many :words, dependent: :nullify

  # callbacks
  before_validation :convert_blank_to_nil, :strip_string_fields
  before_create :mark_user_as_general_by_default

  # validations
  validates :first_name, presence: true, length: {maximum: 15}
  validates :last_name, presence: true, length: {maximum: 15}
  validates :additional_info, presence: false, length: {maximum: 100}
  validates :email, presence: true, uniqueness: true

  # custom methods
  def to_s
    self.email
  end

  def mark_user_as_general_by_default
    self.type ||= General.to_s
  end

  # scopes
end

