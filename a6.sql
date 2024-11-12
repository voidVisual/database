-- First, create the main student table
CREATE TABLE student (
    roll_no INT PRIMARY KEY,
    name VARCHAR2(100),
    marks INT
);
/

-- Insert sample data into student table
INSERT INTO student (roll_no, name, marks) VALUES (1, 'Alice', 37);
INSERT INTO student (roll_no, name, marks) VALUES (2, 'Bob', 39);
INSERT INTO student (roll_no, name, marks) VALUES (3, 'Charlie', 50);
INSERT INTO student (roll_no, name, marks) VALUES (4, 'David', 38);
INSERT INTO student (roll_no, name, marks) VALUES (5, 'Eva', 41);
/

-- View the inserted data
SELECT * FROM student;
/

-- Create the student_copy table
CREATE TABLE student_copy (
    roll_no INT PRIMARY KEY,
    name VARCHAR2(100),
    marks INT
);
/

-- Update marks using implicit cursor
DECLARE
    v_count NUMBER := 0;
BEGIN
    UPDATE student
    SET marks = 40
    WHERE marks BETWEEN 35 AND 39;
    
    v_count := SQL%ROWCOUNT;
    
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE(v_count || ' records have been updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No records were updated.');
    END IF;
END;
/

-- View the updated data
SELECT * FROM student;
/

-- Copy data using explicit cursor
DECLARE
    CURSOR student_cursor IS
        SELECT roll_no, name, marks FROM student;
    
    v_exists NUMBER;
BEGIN
    FOR student_rec IN student_cursor LOOP
        SELECT COUNT(*)
        INTO v_exists
        FROM student_copy
        WHERE roll_no = student_rec.roll_no;
        
        IF v_exists = 0 THEN
            INSERT INTO student_copy (roll_no, name, marks)
            VALUES (student_rec.roll_no, student_rec.name, student_rec.marks);
            DBMS_OUTPUT.PUT_LINE('Record copied for roll_no: ' || student_rec.roll_no);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Record already exists for roll_no: ' || student_rec.roll_no || '. Skipping...');
        END IF;
    END LOOP;
END;
/

-- View the copied data
SELECT * FROM student_copy;
/
