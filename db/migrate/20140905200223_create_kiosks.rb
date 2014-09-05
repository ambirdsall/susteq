class CreateKiosks < ActiveRecord::Migration
  def change
    create_table :kiosks do |t|
      t.integer :location_id
      t.integer :water_service_provider_id
      t.decimal :longitude, {precision: 10, scale: 6}
      t.decimal :latitude, {precision: 10, scale: 6}

      t.timestamps
    end
  end
end
