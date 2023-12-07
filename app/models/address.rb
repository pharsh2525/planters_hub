class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province

  has_many :orders

  validates :address, :city, :postal_code, presence: true
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/ }

  def self.ransackable_attributes(auth_object = nil)
    %w[id address city postal_code user_id province_id] # Add other searchable attributes
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user province] # Add other associations you want to search by
  end
end
