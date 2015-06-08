class AddNumericality < ActiveRecord::Migration
  def change
    add_column :validated_things, :length_numericality_inclusive_value, :decimal, precision: 10, scale: 2
    add_column :validated_things, :length_numericality_inclusive_unit, :string, limit: 12

    add_column :validated_things, :length_numericality_exclusive_value, :decimal, precision: 10, scale: 2
    add_column :validated_things, :length_numericality_exclusive_unit, :string, limit: 12

    add_column :validated_things, :length_numericality_equality_value, :decimal, precision: 10, scale: 2
    add_column :validated_things, :length_numericality_equality_unit, :string, limit: 12

    add_column :validated_things, :length_invalid_comparison_value, :decimal, precision: 10, scale: 2
    add_column :validated_things, :length_invalid_comparison_unit, :string, limit: 12

    add_column :validated_things, :length_non_zero_scalar_value, :decimal, precision: 10, scale: 2
    add_column :validated_things, :length_non_zero_scalar_unit, :string, limit: 12

    add_column :validated_things, :length_zero_scalar_value, :decimal, precision: 10, scale: 2
    add_column :validated_things, :length_zero_scalar_unit, :string, limit: 12
  end
end
