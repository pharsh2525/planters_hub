class PlantImage < ApplicationRecord
  belongs_to :plant

  validates :image_path, presence: true
end
