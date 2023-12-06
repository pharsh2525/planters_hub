class Plant < ApplicationRecord
  belongs_to :category

  has_many :order_items
  has_many_attached :images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    # List only the attributes you want to be searchable
    %w[name description price category_id]
  end

  def self.ransackable_associations(auth_object = nil)
    # List only the associations you want to be searchable
    %w[category]
  end
end
