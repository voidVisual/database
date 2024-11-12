-- Create the database
CREATE DATABASE Tushar;

-- Use the created database
USE Tushar;

-- Create branch_master table
CREATE TABLE branch_master (
    branch_id INT PRIMARY KEY,
    bname VARCHAR(50)
);

-- Create employee_master table
CREATE TABLE employee_master (
    emp_no INT PRIMARY KEY,
    e_name VARCHAR(50),
    branch_id INT,
    salary DECIMAL(10, 2),
    dept VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (branch_id) REFERENCES branch_master(branch_id),
    FOREIGN KEY (manager_id) REFERENCES employee_master(emp_no) ON DELETE SET NULL
);

-- Create contact_details table
CREATE TABLE contact_details (
    emp_id INT,
    emailid VARCHAR(100),
    phnno VARCHAR(15),
    FOREIGN KEY (emp_id) REFERENCES employee_master(emp_no) ON DELETE SET NULL
);

-- Create emp_address_details table
CREATE TABLE emp_address_details (
    emp_id INT,
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    FOREIGN KEY (emp_id) REFERENCES employee_master(emp_no) ON DELETE CASCADE
);

-- Create branch_address table
CREATE TABLE branch_address (
    branch_id INT,
    city VARCHAR(50),
    state VARCHAR(50),
    FOREIGN KEY (branch_id) REFERENCES branch_master(branch_id)
);

-- Inserting records into branch_master
INSERT INTO branch_master (branch_id, bname) VALUES
(1, 'Vadgaon'),
(2, 'Kothrud'),
(3, 'Shivajinagar'),
(4, 'Baner'),
(5, 'Hadapsar');

-- Inserting records into employee_master
INSERT INTO employee_master (emp_no, e_name, branch_id, salary, dept, manager_id) VALUES
(101, 'tushar', 1, 12000, 'Admin', NULL),
(102, 'Amit Patil', 2, 15000, 'Finance', 101),
(103, 'Neha Kulkarni', 1, 11000, 'Admin', 101),
(104, 'Rohit Sharma', 3, 20000, 'IT', NULL),
(105, 'Priya Deshmukh', 2, 18000, 'Admin', 101);

-- Inserting records into contact_details
INSERT INTO contact_details (emp_id, emailid, phnno) VALUES
(101, 'tushar@example.com', '1234567890'),
(102, 'amit@example.com', '1234567891'),
(103, 'neha@example.com', '1234567892'),
(104, 'rohit@example.com', '1234567893'),
(105, 'priya@example.com', '1234567894');

-- Inserting records into emp_address_details
INSERT INTO emp_address_details (emp_id, street, city, state) VALUES
(101, 'MG Road', 'Pune', 'Maharashtra'),
(102, 'JM Road', 'Pune', 'Maharashtra'),
(103, 'FC Road', 'Pune', 'Maharashtra'),
(104, 'Baner Road', 'Pune', 'Maharashtra'),
(105, 'Kothrud', 'Pune', 'Maharashtra');

-- Inserting records into branch_address
INSERT INTO branch_address (branch_id, city, state) VALUES
(1, 'Pune', 'Maharashtra'),
(2, 'Pune', 'Maharashtra'),
(3, 'Pune', 'Maharashtra'),
(4, 'Pune', 'Maharashtra'),
(5, 'Pune', 'Maharashtra');

-- List the employee details along with the branch name using inner join and in order of employee no.
SELECT e.*, b.bname 
FROM employee_master e 
INNER JOIN branch_master b ON e.branch_id = b.branch_id 
ORDER BY e.emp_no;

-- List the details of employees who belong to the Admin department along with the branch name to which they belong.
SELECT e.*, b.bname 
FROM employee_master e 
INNER JOIN branch_master b ON e.branch_id = b.branch_id 
WHERE e.dept = 'Admin';

-- List the employee name along with the phone number and city (using inner join).
SELECT e.e_name, c.phnno, a.city 
FROM employee_master e 
INNER JOIN contact_details c ON e.emp_no = c.emp_id 
INNER JOIN emp_address_details a ON e.emp_no = a.emp_id;

-- List the employee name with the contact details whether they have them or not.
SELECT e.e_name, c.emailid, c.phnno 
FROM employee_master e 
LEFT JOIN contact_details c ON e.emp_no = c.emp_id;