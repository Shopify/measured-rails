class AddScalarNumericalityComparison < ActiveRecord::Migration
  def change
    add_column :validated_things, :length_numericality_less_than_than_scalar_value, :decimal, precision: 10, scale: 2
    add_column :validated_things, :length_numericality_less_than_than_scalar_unit, :string, limit: 12
  end
end
