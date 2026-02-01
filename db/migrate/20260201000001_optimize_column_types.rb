class OptimizeColumnTypes < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :role, 'smallint'
    change_column :tables, :capacity, 'smallint'
    change_column :reservations, :party_size, 'smallint'
    change_column :reservations, :status, 'smallint'
  end
end
#dont run