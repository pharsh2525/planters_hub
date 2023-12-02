class Province < ApplicationRecord
  has_many :addresses

  validates :name, :PST, :GST, :HST, presence: true, uniqueness: { case_sensitive: false }
  validates :PST, :GST, :HST, numericality: { greater_than_or_equal_to: 0 }
end
