-- Creating the database
CREATE DATABASE C35535_Trigger;
USE C35535_Trigger;

-- Creating the Library table
CREATE TABLE Library (
    B_id INT PRIMARY KEY,
    Title VARCHAR(100),
    Edition VARCHAR(50),
    no_of_copies INT
);

-- Creating the Library_Audit table
CREATE TABLE Library_Audit (
    Audit_id INT AUTO_INCREMENT PRIMARY KEY,
    B_id INT,
    Title VARCHAR(100),
    Edition VARCHAR(50),
    no_of_copies INT,
    date_of_mod DATETIME,
    type_of_operation VARCHAR(10),
    user VARCHAR(100)
);

-- Inserting sample records into Library table
INSERT INTO Library (B_id, Title, Edition, no_of_copies)
VALUES
(1, 'Database Systems', '5th', 3),
(2, 'Operating Systems', '3rd', 5),
(3, 'Data Structures', '2nd', 4),
(4, 'Computer Networks', '6th', 2),
(5, 'Artificial Intelligence', '1st', 6);

-- Creating the Transaction table
CREATE TABLE Transaction (
    Transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    Book_id INT,
    Sid INT,
    issue_or_return ENUM('ISSUE', 'RETURN'),
    no_of_copies INT,
    issue_or_return_date DATE,
    FOREIGN KEY (Book_id) REFERENCES Library(B_id)
);

-- Trigger to track updates to the Library table
DELIMITER $$
CREATE TRIGGER library_audit_after_update
AFTER UPDATE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (B_id, Title, Edition, no_of_copies, date_of_mod, type_of_operation, user)
    VALUES (OLD.B_id, OLD.Title, OLD.Edition, OLD.no_of_copies, NOW(), 'UPDATE', USER());
END $$
DELIMITER ;

-- Test Update
UPDATE Library SET no_of_copies = 4 WHERE B_id = 1;

-- View Library_Audit to check the update tracking
SELECT * FROM Library_Audit;

-- Trigger to track deletes from the Library table
DELIMITER $$
CREATE TRIGGER library_audit_after_delete
AFTER DELETE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (B_id, Title, Edition, no_of_copies, date_of_mod, type_of_operation, user)
    VALUES (OLD.B_id, OLD.Title, OLD.Edition, OLD.no_of_copies, NOW(), 'DELETE', USER());
END $$
DELIMITER ;

-- Test Delete
DELETE FROM Library WHERE B_id = 2;

-- View Library_Audit to check the delete tracking
SELECT * FROM Library_Audit;

-- Trigger to check available copies before issuing a book
DELIMITER $$
CREATE TRIGGER check_copies_before_issue
BEFORE INSERT ON Transaction
FOR EACH ROW
BEGIN
    DECLARE available_copies INT;
    SELECT no_of_copies INTO available_copies
    FROM Library
    WHERE B_id = NEW.Book_id;
    IF NEW.issue_or_return = 'ISSUE' AND NEW.no_of_copies > available_copies THEN
        SET NEW.no_of_copies = available_copies;
    END IF;
END $$
DELIMITER ;

-- Test Issue (Exceeding the available copies)
INSERT INTO Transaction (Book_id, Sid, issue_or_return, no_of_copies, issue_or_return_date)
VALUES (1, 101, 'ISSUE', 10, '2024-09-12');

-- View Library after Issue
SELECT * FROM Library;

-- View Transaction table
SELECT * FROM Transaction;

-- Trigger to update the number of copies after issue or return
DELIMITER $$
CREATE TRIGGER update_copies_after_issue_return
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    IF NEW.issue_or_return = 'ISSUE' THEN
        UPDATE Library
        SET no_of_copies = no_of_copies - NEW.no_of_copies
        WHERE B_id = NEW.Book_id;
    ELSEIF NEW.issue_or_return = 'RETURN' THEN
        UPDATE Library
        SET no_of_copies = no_of_copies + NEW.no_of_copies
        WHERE B_id = NEW.Book_id;
    END IF;
END $$
DELIMITER ;

-- Test Issue
INSERT INTO Transaction (Book_id, Sid, issue_or_return, no_of_copies, issue_or_return_date)
VALUES (3, 102, 'ISSUE', 2, '2024-09-12');

-- View Transaction table
SELECT * FROM Transaction;

-- Test Return
INSERT INTO Transaction (Book_id, Sid, issue_or_return, no_of_copies, issue_or_return_date)
VALUES (1, 103, 'RETURN', 1, '2024-09-12');

-- View Library after Return
SELECT * FROM Library;

-- View Transaction table after Return
SELECT * FROM Transaction;
