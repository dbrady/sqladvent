class CreateGameSlots < ActiveRecord::Migration
  def self.up
    create_table :game_slots do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :game_slots
  end
end
