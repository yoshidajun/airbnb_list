class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.date :in_date, nil: false
      t.integer :city_id, nil: false
      t.integer :property_id, nil: false

      t.timestamps
    end

    add_index :vacancies, :property_id
    add_index :vacancies, [:property_id, :in_date], :unique => true
  end
end
