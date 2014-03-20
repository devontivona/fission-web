class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :library
      t.string :version
      t.string :manufacturer
      t.string :os
      t.string :os_version
      t.string :model
      t.string :carrier
      t.string :token

      t.timestamps
    end
  end
end
