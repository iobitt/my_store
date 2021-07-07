class Product < ApplicationRecord

  validates :price, :quantity, numericality: {greater_than: 0, allow_nil: false }
  validates :name, presence: true

  belongs_to :user

end
