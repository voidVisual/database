create database C35535_PRO_FUN;
USE C35535_PRO_FUN;
-- Create tables
CREATE TABLE Stud_Marks (
    Name VARCHAR(50),
    Total_Marks INT
);

CREATE TABLE Result (
    Roll INT PRIMARY KEY,
    Name VARCHAR(50),
    Class VARCHAR(30)
);

-- Create Procedure
DELIMITER $$

CREATE PROCEDURE proc_Grade(
    IN rn INT,
    IN n VARCHAR(50),
    IN m INT
)
BEGIN
    DECLARE class VARCHAR(15);

    IF m >= 990 AND m <= 1500 THEN
        SET class = 'Distinction';
    ELSEIF m >= 900 AND m <= 989 THEN
        SET class = 'First Class';
    ELSEIF m >= 825 AND m <= 899 THEN
        SET class = 'Higher Second Class';
    ELSE
        SET class = 'FAIL';
    END IF;

    INSERT INTO Result (Roll, Name, Class)
    VALUES (rn, n, class);

    INSERT INTO Stud_Marks (Name, Total_Marks)
    VALUES (n, m);
END $$

DELIMITER ;

-- Insert test data
CALL proc_Grade(1, 'Nehaa', 1000);
CALL proc_Grade(2, 'Vihang', 950);
CALL proc_Grade(4, 'Srushti', 920);
CALL proc_Grade(5, 'Mrunmayee', 800);

-- Check data
SELECT * FROM Result;
SELECT * FROM Stud_Marks;

-- Create Function
DELIMITER $$

CREATE FUNCTION get_total_students(class_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM Result
    WHERE Class = class_name;
    
    RETURN total;
END $$

DELIMITER ;
-- Test function
SELECT get_total_students('Distinction') AS Total_Distinction_Students;
SELECT get_total_students('First Class') AS Total_First_Class_Students;
