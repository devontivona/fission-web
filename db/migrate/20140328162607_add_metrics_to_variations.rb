class AddMetricsToVariations < ActiveRecord::Migration
  def change
    add_column :variations, :z_score, :decimal
    add_column :variations, :probability, :decimal
    add_column :variations, :difference, :decimal
  end
end
