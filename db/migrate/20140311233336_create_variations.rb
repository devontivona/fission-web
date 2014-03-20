class CreateVariations < ActiveRecord::Migration
  def change
    create_table :variations do |t|
      t.string :name
      t.integer :experiment_id

      t.timestamps
    end
  end
end
