class AddNotNullConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false

    change_column_null :tables, :name, false
    change_column_null :tables, :capacity, false

    change_column_null :time_slots, :start_time, false
    change_column_null :time_slots, :end_time, false

    change_column_null :reservations, :date, false
    change_column_null :reservations, :party_size, false
  end
end
#safe