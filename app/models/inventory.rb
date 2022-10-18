class Inventory < ApplicationRecord
  belongs_to :standard_part, inverse_of: :inventories

  LOCATIONS = [IL = "IL", PA = "PA"]
  validates :location, inclusion: { in: LOCATIONS }
  validates :carton_count, numericality: { only_integer: true }
  validates :original_carton_count, numericality: { only_integer: true, greater_than: 0 }

  def self.active
    where("carton_count > 0")
  end
end