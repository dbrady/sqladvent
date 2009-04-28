class CreateGameVariables < ActiveRecord::Migration
  def self.up
    create_table :game_variables do |t|
      t.integer :game_slot_id, :null => false
      t.string :name
      t.integer :int_value
    end
    add_index :game_variables, :game_slot_id
  end

  def self.down
    drop_table :game_variables
  end
end
