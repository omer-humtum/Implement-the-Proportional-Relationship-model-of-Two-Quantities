class Quantity
  class ConversionError < StandardError; end

  include Comparable

  attr_reader :value, :uom, :conversions

  def self.zero(uom = UnitOfMeasure::M_PIECES, conversions = {})
    Quantity.new(value: 0, uom: uom, conversions: conversions)
  end

  def initialize(value:, per: false, uom: UnitOfMeasure::M_PIECES, conversions: {})
    @value = value.to_f
    @per = per
    @uom = uom
    @conversions = conversions
  end

  delegate :to_f, :to_d, :to_i, :to_s, to: :value

  def eql?(b)
    @value == b.value && @uom == b.uom
  end

  def hash
    [@value, @uom].hash
  end

  def <=>(r)
    # Do not call verify_quantity, ActiveModel 6.1 does not function if <=> raises
    if r.respond_to?(:to_uom)
      self.value <=> r.to_uom(@uom).value
    else
      nil
    end
  end

  def -@
    Quantity.new(
      value: -self.value,
      uom: @uom,
      conversions: @conversions
    )
  end

  def +(r)
    verify_quantity(r)
    Quantity.new(
      value: self.value + r.to_uom(@uom).value,
      uom: @uom,
      conversions: @conversions
    )
  end

  def -(r)
    verify_quantity(r)
    Quantity.new(
      value: self.value - r.to_uom(@uom).value,
      uom: @uom,
      conversions: @conversions
    )
  end

  def *(r)
    verify_scalar(r)
    Quantity.new(
      value: self.value * r,
      uom: @uom,
      conversions: @conversions
    )
  end

  def proportion(quant2)
    value.to_f / quant2.to_uom(@uom).value
  end

  def /(r)
    verify_scalar(r)
    Quantity.new(
      value: self.value / r,
      uom: @uom,
      conversions: @conversions
    )
  end

  def to_uom(unit_of_measure)
    if @uom == unit_of_measure
      self
    else
      Quantity.new(
        value: @value.send(@per ? :/ : :*, conversion(@uom, unit_of_measure)),
        uom: unit_of_measure,
        conversions: @conversions
      )
    end
  end

  def conversion(original_uom, new_uom)
    @conversions[original_uom].try(:[], new_uom) or raise ConversionError.new("No conversion from #{original_uom} to #{new_uom}")
  end

  private

  def verify_quantity(r)
    unless r.is_a?(Quantity)
      raise ArgumentError.new("Quantity can't do this operation with non-Quantity (got #{r.class})")
    end
  end

  def verify_scalar(r)
    allowed_scalar_types = [Integer, Float, BigDecimal]
    unless allowed_scalar_types.any? {|t| r.kind_of?(t) }
      raise ArgumentError.new("Can only multiply or divide by scalar values (#{allowed_scalar_types.join(", ")}), got #{r.class}")
    end
  end
end
