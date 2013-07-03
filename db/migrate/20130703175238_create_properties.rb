class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :aid, unique: true, nil: false  # AirBnB's Property id
      t.string :name, nil: false
      t.integer :city_id, nil: false

      t.timestamps
    end

    add_index :properties, :aid, :unique => true
    add_index :properties, :city_id
  end
end
