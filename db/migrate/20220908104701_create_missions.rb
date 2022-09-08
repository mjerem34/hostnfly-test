class CreateMissions < ActiveRecord::Migration[6.1]
  def change
    create_table :missions do |t|
      t.date :date, null: false
      t.integer :mission_type, null: false, default: 0
      t.float :price, null: false

      t.references :listing, foreign_key: true

      t.timestamps
    end
  end
end
