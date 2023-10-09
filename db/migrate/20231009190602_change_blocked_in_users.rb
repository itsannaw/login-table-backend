class ChangeBlockedInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :blocked, :boolean, :default => false
  end
end
