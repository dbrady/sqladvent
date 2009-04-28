# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080821043503) do

  create_table "game_slots", :force => true do |t|
    t.string "name"
  end

  create_table "game_variables", :force => true do |t|
    t.integer "game_slot_id", :limit => 11, :null => false
    t.string  "name"
    t.integer "int_value",    :limit => 11
  end

  add_index "game_variables", ["game_slot_id"], :name => "index_game_variables_on_game_slot_id"

  create_table "rooms", :force => true do |t|
    t.string  "name"
    t.text    "desc"
    t.integer "n",    :limit => 11
    t.integer "s",    :limit => 11
    t.integer "e",    :limit => 11
    t.integer "w",    :limit => 11
    t.integer "u",    :limit => 11
    t.integer "d",    :limit => 11
  end

end
