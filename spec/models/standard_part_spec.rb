require 'rails_helper'

describe StandardPart, type: :model do
  describe ".search" do
    before do
      StandardPart.create!(name: "3/8-16 x 1-1/8 : Hex - Cap Screw GR8 ZY", sku: "500491", basic_part_category: "Screws")
      StandardPart.create!(name: "1/2-13 x 1 : Hex - Cap Screw GR8 ZP", sku: "502573", basic_part_category: "Screws")
      StandardPart.create!(name: "1/2-13 x 1-1/2 : Hex - Cap Screw GR8 ZP", sku: "502566", basic_part_category: "Screws")
      StandardPart.create!(name: "1/4-20 x 3 : Hex - Cap Screw GR5 ZP", sku: "502499", basic_part_category: "Screws")
      StandardPart.create!(name: "3/8-16 x 1-1/4 : Hex - Cap Screw GR8 ZP", sku: "500363", basic_part_category: "Screws")
      StandardPart.create!(name: "1/4-20 x 2 : Round Combo Machine Screw GR2 ZP", sku: "502182", basic_part_category: "Screws")
      StandardPart.create!(name: "1/4-20 x 4 : Truss Combo Machine Screw GR2 ZP", sku: "502144", basic_part_category: "Screws")
      StandardPart.create!(name: "10-24 x 3 : Truss Combo Machine Screw GR2 ZP", sku: "502089", basic_part_category: "Screws")
      StandardPart.create!(name: "10-24 x 4 : Round Combo Machine Screw GR2 ZP", sku: "502077", basic_part_category: "Screws")
      StandardPart.create!(name: "10-24 x 5 : Round Combo Machine Screw GR2 ZP", sku: "502073", basic_part_category: "Screws")
      StandardPart.create!(name: "1/4-20 x 3/8 : Hex Flange Bolt GR5 ZY", sku: "404782", basic_part_category: "Bolts")
      StandardPart.create!(name: "1/4-20 x 3-1/2 : Hex Flange Bolt GR5 ZY", sku: "404779", basic_part_category: "Bolts")
      StandardPart.create!(name: "1/4-20 x 3-1/4 : Hex Flange Bolt GR5 ZY", sku: "404777", basic_part_category: "Bolts")
      StandardPart.create!(name: "3/8-16 x 5 : Hex Flange Bolt GR5 ZY", sku: "404693", basic_part_category: "Bolts")
      StandardPart.create!(name: "3/8-24 x 3/4 : Hex Flange Bolt GR5 ZY", sku: "404685", basic_part_category: "Bolts")
      StandardPart.create!(name: "5/16-18 x 2-3/4 : Hex Flange Bolt GR5 ZY", sku: "404648", basic_part_category: "Bolts")
      StandardPart.create!(name: "5/16-18 x 3-1/4 : Hex Flange Bolt GR5 ZY", sku: "404633", basic_part_category: "Bolts")
      StandardPart.create!(name: "5/16-18 x 3-3/4 : Hex Flange Bolt GR5 ZY", sku: "404631", basic_part_category: "Bolts")
      StandardPart.create!(name: "5/16-18 x 7/8 : Hex Flange Bolt GR5 ZY", sku: "404626", basic_part_category: "Bolts")
      StandardPart.create!(name: "5/8-11 x 1-1/2 : Hex Flange Bolt GR5 ZY", sku: "404621", basic_part_category: "Bolts")

      Inventory.create!(standard_part: StandardPart.find_by(sku: "500491"), original_carton_count: 10, carton_count: 5, location: "IL")
      Inventory.create!(standard_part: StandardPart.find_by(sku: "500363"), original_carton_count: 10, carton_count: 5, location: "PA")
      Inventory.create!(standard_part: StandardPart.find_by(sku: "404693"), original_carton_count: 10, carton_count: 0, location: "PA")
      Inventory.create!(standard_part: StandardPart.find_by(sku: "404648"), original_carton_count: 10, carton_count: 1, location: "PA")
    end

    it "finds parts by name" do
      results = StandardPart.search("screw")
      expect(results.count).to eq 10
      expect(results.all? {|r| r.name =~ /Screw/ }).to be true
    end

    it "returns an ActiveRecord Relation" do
      expect(StandardPart.search("screw")).to be_a(ActiveRecord::Relation)
    end

    it "finds parts by name when search terms appear seperately" do
      results = StandardPart.search("5/16 hex bolt")
      expect(results.count).to eq 4
      expect(
        results.all? {|r| r.name.start_with?("5/16-18") && r.name =~ /Hex Flange Bolt/ }
      ).to be true
    end

    it "does not find parts when search terms appear out of order" do
      results = StandardPart.search("hex bolt 5/16")
      expect(results.count).to eq 0
    end

    it "finds parts by SKU" do
      results = StandardPart.search("50207")
      expect(results.count).to eq 2
      expect(results.all? {|r| r.sku.start_with?("50207") }).to be true
    end

    it "filters by part category" do
      results = StandardPart.search("hex", basic_part_category: "Screws")
      expect(results.count).to eq 5
      expect(results.all? {|r| r.name =~ /Screw/ }).to be true
    end

    it "filters by active Inventory location" do
      results = StandardPart.search("3/8-16", location: "PA")
      expect(results.count).to eq 1
      expect(results.first.sku).to eq "500363"
    end

    it "filters by part category and Inventory location" do
      results = StandardPart.search("hex", location: "PA", basic_part_category: "Bolts")
      expect(results.count).to eq 1
      expect(results.first.sku).to eq "404648"
    end
  end
end
