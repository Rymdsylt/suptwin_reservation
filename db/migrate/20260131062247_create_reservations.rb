class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :table, null: false, foreign_key: true
      t.date :date
      t.references :time_slot, null: false, foreign_key: true
      t.integer :party_size
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.integer :status

      t.timestamps
    end
  end
end
