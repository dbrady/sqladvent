-- game_variables.sql - Predefined game slots and variables.

INSERT INTO game_variables (`id`, `game_slot_id`, `name`, `int_value`) VALUES
    (1, 1, 'starting_room_id', 1),
    (2, 2, 'current_game_slot_id', NULL),
    (3, 1, 'mysql dummy val hack', 999);


