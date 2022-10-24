USE lotrfinal_1;
-- SELECT * FROM lotr_book;
-- SELECT * FROM lotr_character;
-- SELECT * FROM lotr_first_encounter;
-- SELECT * FROM lotr_region;
-- SELECT * FROM lotr_species;

-- 1.For each character (found in the lotr_character table) , count the number of encounters documented within the database. Note: a character’s name may appear in two different fields in the encounter table. Each tuple in the result should contain the character’s name and the count of encounters.
SELECT character_name, COUNT(region_name) AS num_encounters 
FROM lotr_character
LEFT OUTER JOIN lotr_first_encounter
ON character1_name = character_name OR character2_name = character_name 
GROUP BY character_name;

-- 2.Count the number of regions each character has visited (as documented in the database). Each tuple in the result should contain the character’s name and the number of regions the character has been documented as visiting as specified in the database. Note: the character’s home region should be included in the count.
SELECT character1_name, COUNT(region_name) AS num_visit
FROM (  SELECT character1_name,region_name FROM lotr_first_encounter
		UNION SELECT character2_name,region_name FROM lotr_first_encounter 
		UNION SELECT character_name,homeland FROM lotr_character
	 )  AS new_encounter
GROUP BY character1_name;

/*SELECT character1_name,region_name FROM lotr_first_encounter
					UNION SELECT character2_name,region_name FROM lotr_first_encounter 
					UNION SELECT character_name,homeland FROM lotr_character*/

-- 3.Count the number of regions whose majority species is ‘hobbit’. The result should consist of a number.
SELECT COUNT(*) AS num_region
FROM lotr_region
WHERE major_species='hobbit';

-- 4.What region has been documented as having the most number of first encounters?
SELECT region_name AS most_num_first_encounter
FROM lotr_first_encounter
GROUP BY region_name
ORDER BY COUNT(region_name) DESC
LIMIT 1;

-- 5.What region has been visited by all characters?
 SELECT region AS region_been_visited_byall
 FROM ( SELECT homeland AS region , COUNT(character_name) AS num_visitor
		FROM  ( SELECT character_name, homeland FROM lotr_character
				UNION SELECT character2_name, region_name FROM lotr_first_encounter 
				UNION SELECT character1_name, region_name FROM lotr_first_encounter
			  ) AS visitor_region_list
		GROUP BY region
	  ) AS visitor_num_list
WHERE num_visitor = (SELECT COUNT(character_name) FROM lotr_character);

/*  SELECT homeland AS region , COUNT(character_name) AS num_visitor
	FROM  ( SELECT character_name, homeland FROM lotr_character
			UNION SELECT character2_name, region_name FROM lotr_first_encounter 
			UNION SELECT character1_name, region_name FROM lotr_first_encounter
		  ) AS visitor_region_list
	GROUP BY region; */

-- 6.Make a separate table from the lotr_first_encounters table – where the records are for the first book. Name the new table book1 encounters.
-- USING ONLY SELECT STATEMENT
SELECT * FROM lotr_first_encounter AS book1_encounters WHERE book_id = 1;

-- USING 'CREATE' STATEMENT
DROP TABLE IF EXISTS book1_encounters;
CREATE TABLE book1_encounters AS SELECT * FROM lotr_first_encounter WHERE book_id = 1;
SELECT * FROM book1_encounters;

-- APPROACH2 WITH 'CREATE'
DROP TABLE IF EXISTS book1_encounters;
CREATE TABLE book1_encounters 
SELECT * FROM lotr_first_encounter AS book1_encounters WHERE book_id = 1;
SELECT * FROM book1_encounters;

-- 7.Which book (book name) does ‘Frodo’ encounter ‘Faramir’? The result should contain the book id and its title. 
SELECT lotr_book.book_id, title 
FROM lotr_book, lotr_first_encounter
WHERE lotr_book.book_id = lotr_first_encounter.book_id AND 
	((character1_name = 'frodo' AND character2_name ='faramir') OR (character1_name = 'faramir' AND character2_name ='frodo'));

-- 8.For each Middle Earth region (each region in the lotr_region table) , create an aggregated field that contains a list of character names that have it as his homeland. The result set should contain the region name and the grouped character names. Do not duplicate names within the grouped list of character names.
SELECT region_name, GROUP_CONCAT(character_name) AS homeland_to
FROM lotr_region
LEFT OUTER JOIN lotr_character
ON  homeland = region_name
GROUP BY region_name;

-- 9.Which is the largest species (by size)?
SELECT species_name 
FROM lotr_species
ORDER BY size DESC
LIMIT 1;

-- 10.How many characters are “human”?
SELECT COUNT(character_name) AS num_human 
FROM lotr_character 
WHERE species='human'; 

-- 11.Make a separate table from the first encounter table – where the tuples are the first encounters between one hobbit and one human. Name the table HumanHobbitFirstEncounters.
/*approach_1*/
SELECT character1_name, character2_name, book_id, region_name 
FROM (  SELECT character1_name, character2_name, book_id, region_name, sp_1, sp_2 
		FROM lotr_first_encounter
		LEFT OUTER JOIN (SELECT character_name AS ch_n1, species AS sp_1 FROM lotr_character) AS sp_info1 ON character1_name = ch_n1
        LEFT OUTER JOIN (SELECT character_name AS ch_n2, species AS sp_2 FROM lotr_character) AS sp_info2 ON character2_name = ch_n2
	 )  AS HumanHobbitFirstEncounters
WHERE (sp_1 = 'hobbit' AND sp_2 = 'human') OR (sp_1 = 'human' AND sp_2 = 'hobbit');
/*SELECT character1_name, character2_name, book_id, region_name, sp_1, sp_2 
		FROM lotr_first_encounter
		LEFT OUTER JOIN (SELECT character_name AS ch_n1, species AS sp_1 FROM lotr_character) AS sp_info1 ON character1_name = ch_n1
        LEFT OUTER JOIN (SELECT character_name AS ch_n2, species AS sp_2 FROM lotr_character) AS sp_info2 ON character2_name = ch_n2;*/
        
/*approach_2*/
SELECT character1_name, character2_name, book_id, region_name 
FROM (  SELECT character1_name, character2_name, book_id, region_name, sp_info1.species sp_1, sp_info2.species sp_2
		FROM lotr_first_encounter
		LEFT OUTER JOIN lotr_character sp_info1 ON character1_name = sp_info1.character_name
        LEFT OUTER JOIN lotr_character sp_info2 ON character2_name = sp_info2.character_name
	 )  AS HumanHobbitFirstEncounters
WHERE (sp_1 = 'hobbit' AND sp_2 = 'human') OR (sp_1 = 'human' AND sp_2 = 'hobbit');
/*SELECT *
		FROM lotr_first_encounter
		LEFT OUTER JOIN lotr_character sp_info1 ON character1_name = sp_info1.character_name
        LEFT OUTER JOIN lotr_character sp_info2 ON character2_name = sp_info2.character_name;*/

-- USING CREATE STATEMENT
DROP TABLE IF EXISTS HumanHobbitFirstEncounters;
CREATE TABLE HumanHobbitFirstEncounters AS 
SELECT character1_name, character2_name, book_id, region_name 
FROM (  SELECT character1_name, character2_name, book_id, region_name, sp_1, sp_2 
		FROM lotr_first_encounter
		LEFT OUTER JOIN (SELECT character_name AS ch_n1, species AS sp_1 FROM lotr_character) AS sp_info1 ON character1_name = ch_n1
        LEFT OUTER JOIN (SELECT character_name AS ch_n2, species AS sp_2 FROM lotr_character) AS sp_info2 ON character2_name = ch_n2
	 )  AS HHFE
WHERE (sp_1 = 'hobbit' AND sp_2 = 'human') OR (sp_1 = 'human' AND sp_2 = 'hobbit');
SELECT * FROM HumanHobbitFirstEncounters;

-- 12.List the names of the characters that have “gondor” listed as their home land.
SELECT GROUP_CONCAT(character_name) AS gondor_char 
FROM lotr_character 
WHERE homeland='gondor';

-- 13.How many characters have “hobbit” listed as their species?
SELECT COUNT(species) AS num_hobbit 
FROM lotr_character 
WHERE species='hobbit';

-- 14.For each Middle Earth region, determine the number of characters from each homeland. The result set should contain the region name and the count of the number of characters. Make sure you do not count characters more than once.
SELECT region_name, COUNT(homeland) AS num_character 
FROM lotr_region
LEFT OUTER JOIN lotr_character 
ON homeland = region_name
GROUP BY region_name;

-- 15.For each character determine the number of first encounters they have had according to the database. Rename the computed number of encounters as encounters. Make sure each character appears in the result. If a character has not had any encounters, the number of encounters should be equal to NULL or 0. 
SELECT character_name, COUNT(region_name) AS encounters 
FROM lotr_character 
LEFT OUTER JOIN lotr_first_encounter 
ON character1_name = character_name OR character2_name = character_name 
GROUP BY character_name;



