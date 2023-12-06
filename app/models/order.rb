class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address

  has_many :order_items
  has_many :plants, through: :order_items

  def self.ransackable_attributes(auth_object = nil)
    %w[id status total user_id address_id] # Add other searchable attributes
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user address] # Add other associations you want to search by
  end
end
