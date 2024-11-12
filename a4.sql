-- Create Borrower table with exact column names matching the block
CREATE TABLE Borrower (
    roll_in NUMBER,
    name VARCHAR2(50),
    date_of_issue DATE,
    name_of_book VARCHAR2(50),
    status CHAR(1)
);

-- Create Fine table
CREATE TABLE Fine (
    roll_no NUMBER,
    date_fine DATE,
    amt NUMBER(10,2)
);

-- Insert sample data with exact column names
INSERT INTO Borrower (roll_in, name, date_of_issue, name_of_book, status) 
VALUES (1, 'John', TO_DATE('01-AUG-2023', 'DD-MON-YYYY'), 'DBMS', 'I');

INSERT INTO Borrower (roll_in, name, date_of_issue, name_of_book, status) 
VALUES (2, 'Smith', TO_DATE('15-JUL-2023', 'DD-MON-YYYY'), 'TOC', 'I');

select * from borrower;


-- The exact PL/SQL block you provided
DECLARE
    roll int := 1;
    b_name varchar(20) := 'DBMS';
    date_issue date;
    no_days int;
    amt int := 0;
    no_days_to_be_fined int := 0;
    ex_valid_roll exception;
BEGIN
    IF roll < 0 THEN 
        RAISE ex_valid_roll;
    END IF;
    
    SELECT date_of_issue INTO date_issue 
    FROM Borrower 
    WHERE roll_in = roll AND name_of_book = b_name;
    
    dbms_output.put_line('Roll no' || date_issue);
    
    no_days := sysdate - date_issue;
    
    IF (no_days > 15 AND no_days < 30) THEN 
        no_days_to_be_fined := no_days - 15;
        amt := no_days_to_be_fined * 5;
        INSERT INTO fine VALUES(roll, sysdate, amt);
    ELSIF (no_days > 30) THEN
        no_days_to_be_fined := no_days - 15;
        amt := no_days_to_be_fined * 50;
        INSERT INTO fine VALUES(roll, sysdate, amt);
    ELSE
        amt := 0;
    END IF;
    
    UPDATE Borrower 
    SET status = 'r' 
    WHERE roll_in = roll AND name_of_book = b_name;

EXCEPTION
    WHEN ex_valid_roll THEN
        dbms_output.put_line('Invalid Roll no');
    WHEN no_data_found THEN
        dbms_output.put_line('Data not Found');
    WHEN others THEN
        dbms_output.put_line('');
END;
/

-- To view results:
SELECT * FROM Borrower;
