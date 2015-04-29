class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|
      t.string :name
      t.string :type, null:false
      t.string :provider_id
      t.string :owner_phone_number
      t.string :owner_sim_number
      t.integer :location_id, null:false
      t.decimal :longitude, {precision: 10, scale: 6}
      t.decimal :latitude, {precision: 10, scale: 6}
      t.integer :status_code, default:1
      t.timestamps
    end
  end
end
