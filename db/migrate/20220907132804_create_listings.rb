class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table :listings do |t|
      t.integer :num_rooms, default: 1, null: false

      t.timestamps
    end
  end
end
