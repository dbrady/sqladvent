-- game.sql - stored procs and logic for the game.

-- ----------------------------------------------------------------------
-- FUNCTION get_slot_id(slot_name)
-- Looks a slot up by name, returns its id.
-- Who says you can't refactor SQL? Here's good old "extract method".
DROP FUNCTION IF EXISTS get_slot_id;
DELIMITER $
CREATE FUNCTION get_slot_id(slot_name VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE slot_id INT DEFAULT 0;
    DECLARE c CURSOR FOR SELECT id FROM game_slots WHERE name=slot_name;
    OPEN c;
    FETCH c INTO slot_id;
    CLOSE c;
    RETURN slot_id;
END$
DELIMITER ;

-- ----------------------------------------------------------------------
-- PROCEDURE delete_game(slot_name)
-- Deletes the named slot.
DROP PROCEDURE IF EXISTS delete_game;
DELIMITER $
CREATE PROCEDURE delete_game (IN slot_name VARCHAR(255))
BEGIN
    DECLARE slot_id INT;
    SELECT get_slot_id(slot_name) INTO slot_id;
    IF slot_id > 0 THEN
        BEGIN
            DELETE FROM game_variables WHERE game_slot_id = slot_id;
            DELETE FROM game_slots WHERE id = slot_id;
        END;
    END IF;
END$
DELIMITER ;

-- -- ----------------------------------------------------------------------
-- PROCEDURE copy_game(src_slot, dst_slot)
-- Copies game data from one game slot to another, creating the
-- dst_slot in the process. Existing dst_slots will be overwritten (no
-- attempt is made to preserve ids).
-- 
-- Okay, this one is a bit more tricksy:
--   - Delete any existing game slot and its variables.
--   - Create the new game slot.
--   - Get a cursor on the source game's variables. For each one,
--     insert that variable's data under the dst_slot_id.
-- 
-- TODO: Raise an error if src_slot does not exist.
DROP PROCEDURE IF EXISTS copy_game;
DELIMITER $
CREATE PROCEDURE copy_game (IN src_slot VARCHAR(255), IN dst_slot VARCHAR(255))
BEGIN
    DECLARE src_slot_id INT;
    DECLARE dst_slot_id INT;
    DECLARE var_name VARCHAR(255);
    DECLARE var_value INT;
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE c CURSOR FOR SELECT name, int_value FROM game_variables WHERE game_slot_id=src_slot_id;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;

    INSERT INTO game_slots (name) VALUES (dst_slot);
    SELECT get_slot_id(dst_slot) INTO dst_slot_id;
    IF dst_slot_id > 0 THEN
        BEGIN
            CALL delete_game(dst_slot);
            SELECT get_slot_id(dst_slot) INTO dst_slot_id;
        END;
    END IF;

    SELECT get_slot_id(src_slot) INTO src_slot_id;

    OPEN c;
    variable_loop: LOOP
        FETCH c INTO var_name, var_value;
        IF done THEN LEAVE variable_loop; END IF;
        INSERT INTO game_variables (game_slot_id, name, int_value) VALUES (dst_slot_id, var_name, var_value);
    END LOOP variable_loop;
    CLOSE c;
END$
DELIMITER ;

-- ----------------------------------------------------------------------
-- PROCEDURE newgame(slot_name)
-- initialize a new game state object for this player.
-- TODO: Raise an error of slot_name already exists
DROP PROCEDURE IF EXISTS newgame;
CREATE PROCEDURE newgame(slot_name VARCHAR(255))
    CALL copy_game('New Game', slot_name);

-- ----------------------------------------------------------------------
-- FUNCTION newgame(slot_name)
-- initialize a new game state object for this player.
DROP FUNCTION IF EXISTS newgame;
DELIMITER $
CREATE FUNCTION newgame(slot_name VARCHAR(255))
RETURNS CHAR(60)
BEGIN
    CALL copy_game('New Game', slot_name);
    RETURN 'Welcome to Adventures in SQL! SELECT help(); for help.';
END$
DELIMITER ;

