class UnitOfMeasure
  ALL = [
    M_PIECES = "M Pieces",
    PIECES = "Pieces",
    C_POUNDS = "C Pounds",
    POUNDS = "Pounds"
  ]

  def self.all
    ALL
  end

  def self.valid_unit?(unit)
    ALL.include?(unit)
  end

  def self.singular_unit_for(unit)
    conversions = {
      PIECES => PIECES,
      M_PIECES => PIECES,
      POUNDS => POUNDS,
      C_POUNDS => POUNDS
    }

    conversions[unit] or raise ArgumentError.new("Unrecognized unit: #{unit}")
  end

  def self.compound_unit_for(unit)
    conversions = {
      PIECES => M_PIECES,
      M_PIECES => M_PIECES,
      POUNDS => C_POUNDS,
      C_POUNDS => C_POUNDS
    }

    conversions[unit] or raise ArgumentError.new("Unrecognized unit: #{unit}")
  end
end