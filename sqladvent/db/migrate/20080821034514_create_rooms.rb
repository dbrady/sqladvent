class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :name
      t.text :desc
      t.integer :n
      t.integer :s
      t.integer :e
      t.integer :w
      t.integer :u
      t.integer :d      
    end
  end

  def self.down
    drop_table :rooms
  end
end
