use lotrfinal_1;

-- 1.	Write a procedure track_character(character_name) that accepts a character name and 
-- returns a result set that contains a list of the other characters that the provided character has encountered. 
-- The result set should contain the character’s name, the region name, the book name, and the name of the encountered character. (10 points)
 DELIMITER //
 DROP PROCEDURE IF EXISTS track_character;
 CREATE PROCEDURE track_character(IN character_name varchar(255))
 BEGIN 
	 SELECT character1_name as character_selected , region_name, title as book_name, character2_name as character_encountered
     FROM(
		  SELECT * FROM lotr_first_encounter
          UNION ALL
          SELECT character2_name, character1_name, book_id, region_name
          FROM lotr_first_encounter
         ) AS encounter_info 
	 JOIN lotr_book USING(book_id)
	 WHERE character1_name = character_name;
 END //
 DELIMITER ;
 -- testing query 
 CALL track_character('frodo');
 CALL track_character('aragorn');
 
-- 2.	Write a procedure track_region(region) that accepts a region name and returns a result set that contains the region name, the book name, the number of encounters for that region and the leader of that region. (10 points)
 DELIMITER //
 DROP PROCEDURE IF EXISTS track_region;
 CREATE PROCEDURE track_region(IN region varchar(255))
 BEGIN
	SELECT region_name, title, num_encounter, leader
    FROM(
		SELECT region_name, leader, num_encounter, title 
        FROM lotr_region
        LEFT OUTER JOIN(
			SELECT region_name, count(region_name) AS num_encounter, book_id
			FROM lotr_first_encounter 
			GROUP BY region_name, book_id
            ) as count_encounter USING (region_name)
		LEFT OUTER JOIN lotr_book USING (book_id)
		) as region_info
	WHERE region_name = region;
 END //
 DELIMITER ;
 -- testing query
 CALL track_region('rivendell');
 CALL track_region('bree');
 CALL track_region('lonely mountain');

-- 3.	rite a function named strongerSpecie(sp1, sp2). It accepts 2 species and returns 1 if sp1 has a size larger than sp2, 0 if they have equal sizes, else -1 (10 points)
 DELIMITER //
 DROP FUNCTION IF EXISTS strongerSpecie;
 CREATE FUNCTION strongerSpecie(sp1 VARCHAR(255), sp2 VARCHAR(255))
 RETURNS INT
 DETERMINISTIC READS SQL DATA
 BEGIN
	DECLARE compare_result INT DEFAULT 0;
    DECLARE size1 INT DEFAULT 0;
    DECLARE size2 INT DEFAULT 0;
    
    SELECT size INTO size1 FROM lotr_species WHERE species_name = sp1;
    SELECT size INTO size2 FROM lotr_species WHERE species_name = sp2;
    
	IF size1 > size2 THEN 
		RETURN 1;
    ELSEIF size1 = size2 THEN
		RETURN 0;
    ELSE
		RETURN -1;
    END IF;
 END //
 DELIMITER ;
 -- testing query
 SELECT strongerSpecie('balrog', 'dwarf') as 'cmp result between balrog and dwarf'; 
 SELECT strongerSpecie('dwarf', 'ent') as 'cmp result between dwarf and ent';
 SELECT strongerSpecie('ent', 'ent') as 'cmp result between dwarf and ent';
 
-- 4.	Write a function named region_most_encounters(character_name) that accepts a character name and returns the name of the region where the character has had the most encounters. (10 points)
 DELIMITER //
 DROP FUNCTION IF EXISTS region_most_encounters;
 CREATE FUNCTION region_most_encounters(character_name VARCHAR(255))
 RETURNS VARCHAR(255)
 DETERMINISTIC READS SQL DATA
 BEGIN
	DECLARE region_returned VARCHAR(255) DEFAULT NULL;
    SELECT region_name INTO region_returned 
    FROM(
		SELECT region_name
        FROM lotr_first_encounter
		WHERE character1_name = character_name OR character2_name = character_name
		GROUP BY region_name
        ORDER BY count(region_name) DESC
        LIMIT 1
        ) AS encounter_info;
    RETURN region_returned;
 END //
 DELIMITER ;
 -- testing query
 SELECT region_most_encounters('frodo') AS result;
 SELECT region_most_encounters('Aragorn') AS result; 
 /*
 what about the situation that a character has encounter each region same times ?
 how should a function return such kind of result ?
 do we have to concat the region names ?
 */
 
-- 5.	Write a function named home_region_encounter(character_name) that accepts a character name and returns TRUE if the character has had a first encounter in his homeland. FALSE if the character has not had a first encounter in his homeland. or NULL if the character’s homeland is not known. (10 points)
-- approach 1 'simple if condition'
 DELIMITER //
 DROP FUNCTION IF EXISTS home_region_encounter;
 CREATE FUNCTION home_region_encounter(character_name VARCHAR(255))
 RETURNS VARCHAR(32) 
 DETERMINISTIC READS SQL DATA
 BEGIN
     DECLARE character_homeland VARCHAR(255) DEFAULT 'NULL';
     
     SELECT homeland INTO character_homeland
     FROM lotr_character WHERE lotr_character.character_name = character_name;
     IF character_homeland = 'NULL' THEN
		RETURN 'NULL';
	 END IF;
     
     IF character_homeland 
		IN ( SELECT region_name FROM lotr_first_encounter
			 WHERE character1_name = character_name OR character2_name = character_name )
        THEN RETURN 'TRUE';
	 ELSE RETURN 'FALSE';
     END IF;
 END //
 DELIMITER ;
 -- testing query
 SELECT home_region_encounter('frodo') as func_result;
 SELECT home_region_encounter('gandalf') as func_result;
 SELECT home_region_encounter('undefine_character') as func_result;
 
-- approach 2 'try using cursor'
 DELIMITER //
 DROP FUNCTION IF EXISTS home_region_encounter;
 CREATE FUNCTION home_region_encounter(character_name VARCHAR(255))
 RETURNS VARCHAR(32) 
 DETERMINISTIC READS SQL DATA
 BEGIN
	 DECLARE character_homeland VARCHAR(255) DEFAULT NULL;
     DECLARE temp_res VARCHAR(32);
     DECLARE search_condition TINYINT DEFAULT TRUE;
     
-- use a cursor to store information about the regions which the character has encountered
     DECLARE region_cursor CURSOR FOR 
		SELECT region_name FROM lotr_first_encounter
        WHERE character1_name = character_name OR character2_name = character_name;
	 DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET search_condition = FALSE;
        
-- find if a character has a homeland
     SELECT homeland INTO character_homeland
     FROM lotr_character WHERE lotr_character.character_name = character_name;
     IF character_homeland = NULL THEN
		RETURN 'NULL';
	 END IF;
     
-- go through the cursor to see if there's a matching region 
     OPEN region_cursor;
     WHILE search_condition = TRUE DO
		FETCH region_cursor INTO temp_res;
        IF temp_res = character_homeland THEN
			RETURN 'TRUE';
		END IF;
	 END WHILE;
	 CLOSE region_cursor;
     RETURN 'FALSE';
 END //
 DELIMITER ;
 -- testing query
 SELECT home_region_encounter('frodo') as func_result;
 SELECT home_region_encounter('gandalf') as func_result;
  /*
  the function will return false if the input is not in the character table 
  since all characters in the table already have a homeland 
  the 'NULL' condition cannot be tested unless we insert a new tuple in the original database
  which might cause unexpected effect.
  */
 
-- 6.	Write a function named encounters_in_num_region(region_name) that accepts a region’s name as an argument and returns the number of encounters for that region. (10 points)
 DELIMITER //
 DROP FUNCTION IF EXISTS encounters_in_num_region;
 CREATE FUNCTION encounters_in_num_region(region_name VARCHAR(255))
 RETURNS INT
 DETERMINISTIC READS SQL DATA
 BEGIN
	DECLARE num_encounter INT DEFAULT 0;
    /*DECLARE CONTINUE HANDLER FOR NOT FOUND
		RETURN num_encounter;*/
    SELECT count(*) as num_count INTO num_encounter
	FROM lotr_first_encounter
    WHERE lotr_first_encounter.region_name = region_name
	GROUP BY region_name;
    RETURN num_encounter;
 END //
 DELIMITER ;
 -- testing query
 SELECT encounters_in_num_region('rivendell') as func_result;
 SELECT encounters_in_num_region('lonely mountain') as func_result; -- test for region with no encounters

-- 7.	Write a procedure named fellowship_encounters(book) that accepts a book’s name and returns the fellowship characters (all fields in the character table) having first encounters in that book. (10 points)
 DELIMITER //
 DROP PROCEDURE IF EXISTS fellowship_encounters;
 CREATE PROCEDURE fellowship_encounters(IN book VARCHAR(255))
 BEGIN 
	DECLARE book_number INT DEFAULT NULL;
    SELECT book_id INTO book_number
	FROM lotr_book
    WHERE title = book;
    
	SELECT * FROM lotr_character
    WHERE character_name IN 
    (SELECT character1_name
     FROM lotr_first_encounter 
     WHERE book_id = book_number UNION
     SELECT character2_name
     FROM lotr_first_encounter
     WHERE book_id = book_number);
    
 END //
 DELIMITER ;
 -- testing query
 CALL fellowship_encounters('the fellowship of the ring');
 CALL fellowship_encounters('the two towers');
 CALL fellowship_encounters('the return of the king');
 
-- 8.	Modify the books table to contain a field called encounters_in_book and write a procedure called initialize_encounters_count(book) that accepts a book id and initializes the field to the number of encounters that occur in that book for the current encounters table. The book table modification can occur outside or inside of the procedure. (10 points)
-- ADD FIELD AS REQUESTED 
 	ALTER TABLE lotrfinal_1.lotr_book DROP encounters_in_book;
 	ALTER TABLE lotrfinal_1.lotr_book ADD encounters_in_book INT DEFAULT NULL ;
-- PROCEDURE PART
 DELIMITER // 
 DROP PROCEDURE IF EXISTS initialize_encounters_count;
 CREATE PROCEDURE initialize_encounters_count(IN book VARCHAR(255))
 BEGIN 
	UPDATE lotrfinal_1.lotr_book
    SET encounters_in_book = (SELECT COUNT(*) FROM lotr_first_encounter WHERE book_id = book GROUP BY book_id )
    WHERE book_id = book;
 END //
 DELIMITER ;
 -- testing query
 CALL initialize_encounters_count(1);
 CALL initialize_encounters_count(2);
 CALL initialize_encounters_count(3);
 SELECT * FROM lotr_book;
 
-- 9.	Write a trigger that updates the field encounters_in_book for the book records in the lotr_book table. The field should contain the number of first encounters for that book.  Call the trigger firstencounters_after_insert. Insert the following records into the database.  Insert a first encounter in Rivendell between Legolas and Frodo for book 1. Ensure that the sencounters_in_book field is properly updated for this data. (10 points)
 DELIMITER //
 DROP TRIGGER IF EXISTS AFTER_lotr_first_encounter_INSERT;
 CREATE TRIGGER AFTER_lotr_first_encounter_INSERT
 AFTER INSERT ON lotr_first_encounter
 FOR EACH ROW
 BEGIN
	CALL initialize_encounters_count(NEW.book_id);
 END //
 DELIMITER ;
-- Insert a first encounter in Rivendell between Legolas and Frodo for book 1
DELETE FROM lotr_first_encounter WHERE character1_name ='Legolas' AND character2_name = 'Frodo';
INSERT INTO lotr_first_encounter(character1_name, character2_name, book_id, region_name)
VALUES ('Legolas','Frodo',1,'Rivendell');
-- testing query
SELECT * FROM lotr_first_encounter;
SELECT * FROM lotr_book;

-- 10.	Create and execute a prepared statement from the SQL workbench that calls home_region_encounter with the argument ‘Aragorn’. Use a user session variable to pass the argument to the function. (5 points)
 PREPARE stmt1 FROM 'SELECT home_region_encounter(?) AS result_Q10';
 SET @a1 = 'Aragorn';
 EXECUTE stmt1 USING @a1;
 
-- 11.	Create and execute a prepared statement that calls region_most_encounters() with the argument ‘Aragorn’. Once again use a user session variable to pass the argument to the function. (5 points)
PREPARE stmt2 FROM 'SELECT region_most_encounters(?) AS result_Q11';
SET @b1 = 'Aragorn';
EXECUTE stmt2 USING @b1;

