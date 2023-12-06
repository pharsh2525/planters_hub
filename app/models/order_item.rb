class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :plant

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[order_id plant_id quantity unit_price] # Add other attributes you want searchable
  end
end
