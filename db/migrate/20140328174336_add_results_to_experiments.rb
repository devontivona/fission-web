class AddResultsToExperiments < ActiveRecord::Migration
  def change
    add_column :experiments, :best_variation_id, :integer
    add_column :experiments, :base_variation_id, :integer
    add_column :experiments, :worst_variation_id, :integer
    add_column :experiments, :choice_variation_id, :integer
    add_column :experiments, :outcome_variation_id, :integer
  end
end
