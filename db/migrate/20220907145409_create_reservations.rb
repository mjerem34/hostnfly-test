class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.references :listing, foreign_key: true, index: { unique: true }

      t.timestamps
    end

    add_index :reservations, [:listing_id, :start_date, :end_date], unique: true
  end
end
