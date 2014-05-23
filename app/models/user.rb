class User < ActiveRecord::Base
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

  # scopes



end
