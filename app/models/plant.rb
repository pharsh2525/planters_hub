class Plant < ApplicationRecord
  belongs_to :category

  has_many :order_items
  has_many_attached :images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
