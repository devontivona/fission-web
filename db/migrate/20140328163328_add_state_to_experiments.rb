class AddStateToExperiments < ActiveRecord::Migration
  def change
    add_column :experiments, :is_active, :boolean, :default => true
  end
end
