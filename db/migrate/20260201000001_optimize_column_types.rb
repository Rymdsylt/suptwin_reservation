class OptimizeColumnTypes < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :role, 'smallint'
    change_column :tables, :capacity, 'smallint'
    change_column :reservations, :party_size, 'smallint'
    change_column :reservations, :status, 'smallint'
    add_index :reservations, :date
    add_index :reservations, [:date, :time_slot_id, :status]
    add_index :reservations, :status
    add_index :users, :email, unique: true
  end
end
#dont run