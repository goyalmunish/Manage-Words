require 'common_model'
class User < ActiveRecord::Base
  include CommonModel # custom library placed in lib directory, containing methods common to all models
  # associations
  has_many :words

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validations
  validates :first_name, presence: true, length: {maximum: 15}
  validates :last_name, presence: true, length: {maximum: 15}
  validates :additional_info, presence: false, length: {maximum: 100}
  validates :email, presence: true, uniqueness: true


  # callbacks
  before_validation :convert_blank_to_nil
  before_save :convert_blank_to_nil

  # scopes



end
