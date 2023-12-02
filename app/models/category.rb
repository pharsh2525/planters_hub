class Category < ApplicationRecord
  has_many :plants

  validates :category_name, presence: true, uniqueness: { case_sensitive: false }
end
