class User < ApplicationRecord

  has_secure_password
  has_many :posts

  before_save {self.email = email.downcase}
  validates :user_name, {presence: true}
  validates :full_name, {presence: true}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, {presence: true, format: {with: VALID_EMAIL_REGEX},
                     uniqueness: {case_sensitive: false}}
  validates :password, {length: {minimum: 6}}
end