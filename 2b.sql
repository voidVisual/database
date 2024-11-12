CREATE DATABASE hospitaldb;
use hospitaldb;
-- 1. Create Patient Table
CREATE TABLE Patient (
    pat_id VARCHAR(5) PRIMARY KEY,
    pat_name VARCHAR(50),
    date_adm DATE,
    age INT,
    city VARCHAR(50),
    email VARCHAR(100)
);

-- 2. Create Doctor Table
CREATE TABLE Doctor (
    doc_id VARCHAR(5) PRIMARY KEY,
    doc_name VARCHAR(50),
    qualification VARCHAR(50),
    exp INT,
    dept VARCHAR(50),
    city VARCHAR(50),
    salary DECIMAL(10, 2)
);

-- 3. Create Treats Table with foreign key references
CREATE TABLE Treats (
    doc_id VARCHAR(5),
    pat_id VARCHAR(5),
    disease VARCHAR(50),
    fees DECIMAL(10, 2),
    FOREIGN KEY (doc_id) REFERENCES Doctor(doc_id) ON DELETE CASCADE,
    FOREIGN KEY (pat_id) REFERENCES Patient(pat_id) ON DELETE SET NULL
);

-- Insert Data
-- 4. Insert data into Patient
INSERT INTO Patient (pat_id, pat_name, date_adm, age, city, email) VALUES
('P1', 'Om', '2024-02-22', 24, 'Pune', 'xyz1@mail.com'),
('P2', 'Ved', '2024-03-22', 24, 'Pune', 'xyz2@mail.com'),
('P3', 'Neha', '2024-04-22', 24, 'Pune', 'xyz3@mail.com'),
('P4', 'Aditi', '2024-05-22', 24, 'Pune', 'xyz4@mail.com'),
('P5', 'Rishi', '2024-06-22', 24, 'Pune', 'xyz5@mail.com');

-- 5. Insert data into Doctor
INSERT INTO Doctor (doc_id, doc_name, qualification, exp, dept, city, salary) VALUES
('D1', 'Prajwal', 'Mbbs', 3, 'Ortho', 'Pune', 9234849),
('D2', 'Pranay', 'Md', 4, 'Physician', 'Pune', 2349334),
('D3', 'Madhura', 'Md', 5, 'Cardio', 'Pune', 239334),
('D4', 'Doc2', 'Md', 6, 'Neuro', 'Pune', 2349334),
('D5', 'Doc3', 'Md', 7, 'Physician', 'Pune', 2439334);

-- 6. Insert data into Treats
INSERT INTO Treats (doc_id, pat_id, disease, fees) VALUES
('D1', 'P5', 'Cancer', 90000),
('D2', 'P4', 'Heart attack', 890234),
('D3', 'P3', 'Fever', 890234),
('D4', 'P2', 'Flu', 890234),
('D5', 'P1', 'Cancer', 890234);

-- Queries
-- 7. Display all patients' names between age 18-50
SELECT pat_name FROM Patient WHERE age BETWEEN 18 AND 50;

-- 8. Display doctors with qualification "MD"
SELECT doc_name FROM Doctor WHERE qualification = 'Md';

-- 9. Display doctors with more than 20 years of experience
SELECT doc_name FROM Doctor WHERE exp > 20;

-- 10. Display patients suffering from Cancer
SELECT pat_name FROM Patient p JOIN Treats t ON p.pat_id = t.pat_id WHERE t.disease = 'Cancer';

-- 11. Display patient and doctor names for cancer treatment
SELECT p.pat_name, d.doc_name FROM Patient p 
JOIN Treats t ON p.pat_id = t.pat_id 
JOIN Doctor d ON t.doc_id = d.doc_id 
WHERE t.disease = 'Cancer';

-- 12. Display patient names with 5 letters starting with 'A' and ending with 'A'
SELECT pat_name FROM Patient WHERE pat_name LIKE 'A___A';

-- 13. Delete patients with Pat_id 'P10'
DELETE FROM Patient WHERE pat_id = 'P10';

-- 14. Delete doctor records with name "Suhas"
DELETE FROM Doctor WHERE doc_name = 'Suhas';

-- 15. Change qualification for "Shubham" from "Mbbs" to "Md"
UPDATE Doctor SET qualification = 'Md' WHERE doc_name = 'Shubham' AND qualification = 'Mbbs';

-- 16. Salary raise: 5% for Dentist, 10% for Cardiologists
UPDATE Doctor SET salary = salary * CASE WHEN dept = 'Dentist' THEN 1.05 WHEN dept = 'Cardio' THEN 1.10 END WHERE dept IN ('Dentist', 'Cardio');

-- 17. Display total salary by department
SELECT dept, SUM(salary) AS total_salary FROM Doctor GROUP BY dept;

-- 18. Find department with highest average salary
SELECT dept FROM Doctor GROUP BY dept ORDER BY AVG(salary) DESC LIMIT 1;

-- 19. Average salary of "Dentist" department
SELECT AVG(salary) AS avg_salary FROM Doctor WHERE dept = 'Dentist';

-- 20. Departments with average salary above 50,000
SELECT dept FROM Doctor GROUP BY dept HAVING AVG(salary) > 50000;

-- 21. Total number of doctors
SELECT COUNT(*) AS num_doctors FROM Doctor;

-- 22. Cities where either doctors or patients live
SELECT DISTINCT city FROM Doctor UNION SELECT DISTINCT city FROM Patient;

-- 23. Cities where both doctors and patients live
SELECT city FROM Doctor INTERSECT SELECT city FROM Patient;

-- 24. Display doctors without patients
SELECT doc_name FROM Doctor WHERE doc_id NOT IN (SELECT DISTINCT doc_id FROM Treats);

-- 25. Display names of doctors and patients as a single column (Union All)
SELECT doc_name AS name FROM Doctor UNION ALL SELECT pat_name AS name FROM Patient;

-- 26. Total money collected from treatments
SELECT SUM(fees) AS total_money_collected FROM Treats;

-- 27. Average salary of each department
SELECT dept, AVG(salary) AS avg_salary FROM Doctor GROUP BY dept;

-- 28. Display patients without email
SELECT pat_name FROM Patient WHERE email IS NULL OR email = '';