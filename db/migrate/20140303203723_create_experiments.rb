class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.string :name
      t.integer :app_id

      t.timestamps
    end
  end
end
