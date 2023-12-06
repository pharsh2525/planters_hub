class Province < ApplicationRecord
  has_many :addresses

  validates :name, :PST, :GST, :HST, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :PST, :GST, :HST, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[name PST GST HST]
  end
end
