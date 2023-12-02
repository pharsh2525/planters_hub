class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province

  has_many :orders

  validates :address, :city, :postal_code, presence: true
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/ }
end
