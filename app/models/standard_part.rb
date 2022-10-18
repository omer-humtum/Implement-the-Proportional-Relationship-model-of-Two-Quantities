class StandardPart < ApplicationRecord
  has_many :inventories

  validates :name, presence: true
  validates :basic_part_category, presence: true

  def self.search(n, where_clause = {})
    scope = build_joins(where_clause).where("name like ? or sku like ?", "%#{n.split(' ').join('%')}%", "%#{n}%")
    location = where_clause.delete(:location)
    if location
      scope = scope.where('inventories.location = ?', location)
    end
    scope.where(where_clause)
  end

  def self.build_joins(where_clause)
    if where_clause[:location]
      joins(:inventories).merge(Inventory.active)
    else
      self
    end
  end
end
