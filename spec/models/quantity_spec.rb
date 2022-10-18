require 'rails_helper'

describe Quantity, type: :model do
  let(:default_conversions) do
    {
      UnitOfMeasure::M_PIECES => {
        UnitOfMeasure::C_POUNDS => 0.625
      },
      UnitOfMeasure::C_POUNDS => {
        UnitOfMeasure::M_PIECES => 1.6
      }
    }
  end

  def quantity(value, uom = UnitOfMeasure::M_PIECES, conversions = default_conversions)
    Quantity.new(value: value, uom: uom, conversions: conversions)
  end

  describe ".<=>" do
    it "compares two C Pound" do
      expect(
        quantity(100.0, UnitOfMeasure::C_POUNDS) <=> quantity(100, UnitOfMeasure::C_POUNDS)
      ).to eq 0

      expect(
        quantity(100.5, UnitOfMeasure::C_POUNDS) <=> quantity(100, UnitOfMeasure::C_POUNDS)
      ).to eq 1

      expect(
        quantity(100.5, UnitOfMeasure::C_POUNDS) <=> quantity(101, UnitOfMeasure::C_POUNDS)
      ).to eq -1
    end

    it "compares an M Piece with a C Pound" do
      expect(
        quantity(100.0) <=> quantity(62.5, UnitOfMeasure::C_POUNDS)
      ).to eq 0

      expect(
        quantity(100.5) <=> quantity(62.8, UnitOfMeasure::C_POUNDS)
      ).to eq 1

      expect(
        quantity(100.5) <=> quantity(62.9, UnitOfMeasure::C_POUNDS)
      ).to eq -1
    end

    it "compares a C Pound with an M Piece" do
      expect(
        quantity(1, UnitOfMeasure::C_POUNDS) <=> quantity(1.6)
      ).to eq 0

      expect(
        quantity(1.05, UnitOfMeasure::C_POUNDS) <=> quantity(1.6)
      ).to eq 1

      expect(
        quantity(0.99, UnitOfMeasure::C_POUNDS) <=> quantity(1.6)
      ).to eq -1
    end
  end

  describe ".+" do
    it "supports addition with another Quantity" do
      expect(
        quantity(1) + quantity(2)
      ).to eq quantity(3, UnitOfMeasure::M_PIECES)

      expect(
        quantity(1, UnitOfMeasure::C_POUNDS) + quantity(1, UnitOfMeasure::C_POUNDS)
      ).to eq quantity(2, UnitOfMeasure::C_POUNDS)

      expect(
        quantity(1, UnitOfMeasure::M_PIECES) + quantity(1, UnitOfMeasure::C_POUNDS)
      ).to eq quantity(2.6, UnitOfMeasure::M_PIECES)
    end

    it "raises an exception when attempting to add a non-Quantity" do
      expect {
        quantity(1) + 1
      }.to raise_error ArgumentError
    end
  end


  describe ".-" do
    it "supports subtraction with another Quantity" do
      expect(
        quantity(3) - quantity(2)
      ).to eq quantity(1, UnitOfMeasure::M_PIECES)

      expect(
        quantity(1, UnitOfMeasure::C_POUNDS) - quantity(1, UnitOfMeasure::C_POUNDS)
      ).to eq quantity(0, UnitOfMeasure::C_POUNDS)

      expect(
        quantity(1, UnitOfMeasure::C_POUNDS) - quantity(1, UnitOfMeasure::M_PIECES)
      ).to eq quantity(0.375, UnitOfMeasure::C_POUNDS)
    end

    it "raises an exception when attempting to add a non-Quantity" do
      expect {
        quantity(1) - 1
      }.to raise_error ArgumentError
    end
  end

  describe ".*" do
    it "supports multiplication by a scalar" do
      expect(
        quantity(2, UnitOfMeasure::M_PIECES) * 0.9
      ).to eq quantity(1.8, UnitOfMeasure::M_PIECES)
    end

    it "raises an exception when attempting to multiply a Quantity" do
      expect {
        quantity(1) * quantity(1)
      }.to raise_error ArgumentError
    end
  end

  describe "./" do
    it "supports division by a scalar" do
      expect(
        quantity(2, UnitOfMeasure::M_PIECES) / 0.5
      ).to eq quantity(4.0, UnitOfMeasure::M_PIECES)
    end

    it "raises an exception when attempting division by a Quantity" do
      expect {
        quantity(1) / quantity(1)
      }.to raise_error ArgumentError
    end
  end

  describe "proportion" do
    it "calculates correctly in same unit" do
      q1 = quantity(2, UnitOfMeasure::M_PIECES)
      q2 = quantity(4, UnitOfMeasure::M_PIECES)
      expect(q1.proportion(q2)).to eq 0.5
      expect(q2.proportion(q1)).to eq 2
    end

    it "compares across different units correctly" do
      q1 = quantity(1, UnitOfMeasure::C_POUNDS)
      q2 = quantity(3.2)
      expect(q1.proportion(q2)).to eq 0.5
      expect(q2.proportion(q1)).to eq 2
    end
  end
end
