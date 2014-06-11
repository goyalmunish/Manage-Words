require 'common_model'
class User < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models

  # include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # CONSTANTS

  # ASSOCIATIONS
  has_many :words, dependent: :nullify
  has_and_belongs_to_many :dictionaries

  # CALLBACKS
  before_validation :convert_blank_to_nil, :strip_string_fields
  before_create :mark_user_as_general_by_default

  # VALIDATIONS
  validates :first_name, presence: true, length: {maximum: 15}
  validates :last_name, presence: true, length: {maximum: 15}
  validates :additional_info, presence: false, length: {maximum: 100}
  validates :email, presence: true, uniqueness: true

  # CUSTOM METHODS
  def to_s
    self.email
  end

  def mark_user_as_general_by_default
    self.type ||= General.to_s
  end

  # SCOPES

  # ACCESS
  protected :mark_user_as_general_by_default
end

