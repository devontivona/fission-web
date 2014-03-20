class AddAppIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :app_id, :integer
  end
end
