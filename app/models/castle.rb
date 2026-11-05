class Castle < ApplicationRecord
  before_validation :set_search_text
  belongs_to :user
  validates :name, :region, :location, :description, presence: true
  validates :name, :region, :location, length: { maximum: 150 }
  validates :description, length: { maximum: 10_000 }
  validates :built_year, numericality: { only_integer: true, greater_than: 0,
                                       less_than_or_equal_to: ->(_) { Date.current.year } }, allow_nil: true

  private

  def set_search_text
    self.search_text = "#{name} #{location}".downcase
  end
end
