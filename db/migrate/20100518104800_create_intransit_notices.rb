class CreateIntransitNotices < ActiveRecord::Migration
  def self.up
    create_table :intransit_notices do |t|
      t.integer :package_id
      t.integer :tag_sequence
      t.string :status
      t.datetime :recorded_at
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :intransit_notices
  end
end
