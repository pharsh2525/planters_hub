# app/models/page.rb
class Page < ApplicationRecord
  before_validation :generate_slug, on: :create

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  private

  def generate_slug
    self.slug = title.parameterize if title
  end

  def self.ransackable_attributes(auth_object = nil)
    # List the attributes you want to be searchable
    %w[id title content slug created_at updated_at]
  end

end
