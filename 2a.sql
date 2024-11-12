CREATE DATABASE university;
USE university;

-- Create the 'Department' table with a unique department number and department name
CREATE TABLE Department (
    dept_no INT PRIMARY KEY, 
    dept_name VARCHAR(100) UNIQUE, 
    building_name VARCHAR(100)
);

-- Create the 'Instructor' table with a foreign key referencing 'Department' table
CREATE TABLE Instructor (
    ins_id INT PRIMARY KEY, 
    ins_name VARCHAR(100) NOT NULL, 
    dept_no INT, 
    salary DECIMAL(10,2), 
    mob_no VARCHAR(15),
    FOREIGN KEY (dept_no) REFERENCES Department(dept_no)
);

-- Create the 'Course' table with a foreign key to 'Department'
CREATE TABLE Course (
    course_id INT PRIMARY KEY, 
    title VARCHAR(100), 
    dept_no INT, 
    credits INT, 
    FOREIGN KEY (dept_no) REFERENCES Department(dept_no)
);

-- Create the 'Teaches' table to map instructors to courses, with composite primary key and foreign keys
CREATE TABLE Teaches (
    teacher_id INT, 
    course_id INT, 
    semester VARCHAR(10),  
    year INT, 
    PRIMARY KEY (teacher_id, course_id, semester, year),  
    FOREIGN KEY (teacher_id) REFERENCES Instructor(ins_id), 
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- Insert data into 'Department' table
INSERT INTO Department (dept_no, dept_name, building_name) 
VALUES 
    (1, 'Computer Science', 'Building A'), 
    (2, 'Electrical Engineering', 'Building B'),  
    (3, 'Mechanical Engineering', 'Building C'), 
    (4, 'Civil Engineering', 'Building D');

-- Insert data into 'Instructor' table
INSERT INTO Instructor (ins_id, ins_name, dept_no, salary, mob_no) 
VALUES  
    (101, 'tushar', 1, 75000.00, '9876543210'), 
    (102, 'Prajwal Jadhav', 2, 85000.00, '9876543211'), 
    (103, 'Neha KilledarPatil', 1, 95000.00, '9876543212'),  
    (104, 'Ved Kashayap', 3, 70000.00, '9876543213'), 
    (105, 'reder', 4, 68000.00, '9876543214');

-- Insert data into 'Course' table
INSERT INTO Course (course_id, title, dept_no, credits)
VALUES 
    (201, 'Introduction to Programming', 1, 4), 
    (202, 'Data Structures', 1, 3), 
    (203, 'Circuits Analysis', 2, 3), 
    (204, 'Thermodynamics', 3, 3), 
    (205, 'Structural Engineering', 4, 4);

-- Insert data into 'Teaches' table
INSERT INTO Teaches (teacher_id, course_id, semester, year)
VALUES 
    (101, 201, 'Fall', 2024), 
    (102, 203, 'Spring', 2024), 
    (103, 202, 'Fall', 2024), 
    (104, 204, 'Spring', 2024), 
    (105, 205, 'Fall', 2024);

-- Add a new column 'budget' to 'Department' table
ALTER TABLE Department ADD budget DECIMAL(15,2);

-- Create a unique index on 'mob_no' column in 'Instructor' table
CREATE UNIQUE INDEX idx_mob_no ON Instructor(mob_no);

-- Create a view 'instructor_view' with selected columns from 'Instructor' table
CREATE VIEW instructor_view AS 
SELECT ins_id, ins_name, dept_no, mob_no FROM Instructor;

-- Insert data into the view 'instructor_view' which also inserts into 'Instructor' table
INSERT INTO instructor_view (ins_id, ins_name, dept_no, mob_no) 
VALUES (106, 'John Doe', 1, '3876543210');

-- Update the department number for a specific instructor in 'instructor_view'
UPDATE instructor_view 
SET dept_no = 2 WHERE ins_id = 101;

-- Drop the view 'instructor_view'
DROP VIEW instructor_view;

-- Remove the 'budget' column from the 'Department' table
ALTER TABLE Department DROP COLUMN budget;

-- Modify the 'title' column in 'Course' table to allow for a longer text size
ALTER TABLE Course MODIFY title VARCHAR(255);

-- Drop the unique index on 'mob_no' column in 'Instructor' table
DROP INDEX idx_mob_no ON Instructor;

-- Rename the 'Course' table to 'NewCourse'
RENAME TABLE Course TO NewCourse;

-- Create a view 'instructor_course_view' to join 'Instructor' and 'NewCourse' via 'Teaches' table
CREATE VIEW instructor_course_view AS 
SELECT i.ins_name, c.title 
FROM Instructor i 
JOIN Teaches t ON i.ins_id = t.teacher_id 
JOIN NewCourse c ON t.course_id = c.course_id;

-- Set 'course_id' column in 'NewCourse' to auto-increment and adjust the starting value
ALTER TABLE NewCourse MODIFY course_id INT AUTO_INCREMENT;
ALTER TABLE NewCourse AUTO_INCREMENT = 51;

-- Create a new database 'UniversityDB'
CREATE DATABASE UniversityDB;

-- Create a simple table 'NewTable' in the selected database
CREATE TABLE NewTable (
    column1 INT, 
    column2 VARCHAR(50)
);

-- Add 'ON DELETE CASCADE' constraint to 'Instructor' table on 'dept_no' column
ALTER TABLE Instructor 
ADD CONSTRAINT fk_instructor_dept  
FOREIGN KEY (dept_no) REFERENCES Department(dept_no) 
ON DELETE CASCADE;

-- Add 'ON DELETE CASCADE' constraint to 'Teaches' table for 'teacher_id' referencing 'Instructor'
ALTER TABLE Teaches 
ADD CONSTRAINT fk_teaches_instructor 
FOREIGN KEY (teacher_id) REFERENCES Instructor(ins_id) 
ON DELETE CASCADE;

-- Remove all records from 'Instructor' table
TRUNCATE TABLE Instructor;

-- Drop the 'Teaches' table
DROP TABLE Teaches;
