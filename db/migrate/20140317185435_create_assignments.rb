class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :client_id
      t.integer :variation_id

      t.timestamps
    end
  end
end
