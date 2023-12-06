class Category < ApplicationRecord
  has_many :plants

  validates :category_name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(auth_object = nil)
    %w[category_name]
  end
end
