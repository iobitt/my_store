class User < ApplicationRecord
  has_secure_password validations: false

  validates :name, length: { in: 3..20 }, allow_nil: true, uniqueness: true
  validates :password, length: { in: 8..20 }, allow_nil: true
  validates :token, length: { minimum: 32 }, allow_nil: true, uniqueness: true
  validates :type, presence: true

  has_many :products
end
