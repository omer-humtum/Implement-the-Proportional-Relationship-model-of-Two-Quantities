class CreateStandardParts < ActiveRecord::Migration[7.0]
  def change
    create_table "standard_parts" do |t|
      t.string "name", null: false
      t.string "basic_part_category", null: false
      t.string "sku", null: false
      t.float "m_piece_per_c_pound"
    end
  end
end
