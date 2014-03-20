class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.string :access_token

      t.timestamps
    end
  end
end
