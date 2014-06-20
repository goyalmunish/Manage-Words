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
  # has_and_belongs_to_many :dictionaries
  has_many :dictionaries_users
  has_many :dictionaries, through: :dictionaries_users

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

  def self.data_backup_for_all_users(users = User.includes(:words => :flags).all)
    data = Array.new
    users.each do |user|
      temp_hash = {
          :email => user.email,
          :words => Word.data_backup(user.words.includes(:flags))
      }
      data << temp_hash
    end
    return data
  end

  def self.restore_backup_for_all_users(array_data)
    word_count = 0
    array_data.each do |hash_data|
      user = User.where(:email => hash_data['email']).first
      if user
        temp_count = Word.restore_backup(user.id, hash_data['words'])
        word_count += temp_count
      end
    end
    return word_count
  end

  # SCOPES
  default_scope -> { order(:id => :asc) }

  # ACCESS
  protected :mark_user_as_general_by_default
end
