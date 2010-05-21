class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :description
      t.string :serial_number
      t.integer :customer_id
      t.integer :carrier_id

      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
