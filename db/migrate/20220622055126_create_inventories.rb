class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table "inventories" do |t|
      t.integer "carton_count", null: false
      t.integer "original_carton_count", null: false
      t.string "location", null: false
      t.bigint "standard_part_id", null: false
      t.index ["standard_part_id"], name: "index_inventories_on_standard_part_id"
    end
  end
end
