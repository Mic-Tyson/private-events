class AddStatusToEventsUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :events_users, :status, :integer, default: 0
  end
end
