-- Portfolio 1: Database design schema for XYZ University
-- Project: Design and Implementation of a Relational Database Management System for XYZ University

DROP TABLE IF EXISTS registration CASCADE;
DROP TABLE IF EXISTS lecturer_course CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS lecturer CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS department CASCADE;

CREATE TABLE department (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    faculty VARCHAR(100) NOT NULL
);

CREATE TABLE student (
    student_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    department_id VARCHAR(10) NOT NULL,
    level INT NOT NULL CHECK (level BETWEEN 100 AND 500),
    email VARCHAR(100) NOT NULL UNIQUE,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE lecturer (
    lecturer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id VARCHAR(10) NOT NULL,
    designation VARCHAR(50) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE course (
    course_id VARCHAR(10) PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_title VARCHAR(100) NOT NULL,
    credit_unit INT NOT NULL CHECK (credit_unit > 0),
    department_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE lecturer_course (
    assignment_id VARCHAR(10) PRIMARY KEY,
    lecturer_id VARCHAR(10) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    FOREIGN KEY (lecturer_id) REFERENCES lecturer(lecturer_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    UNIQUE (lecturer_id, course_id, semester, academic_year)
);

CREATE TABLE registration (
    registration_id VARCHAR(10) PRIMARY KEY,
    student_id VARCHAR(10) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    registration_status VARCHAR(20) NOT NULL CHECK (registration_status IN ('Approved', 'Pending')),
    score INT,
    grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    UNIQUE (student_id, course_id, semester, academic_year),
    CHECK (score IS NULL OR (score BETWEEN 0 AND 100)),
    CHECK (grade IS NULL OR grade IN ('A', 'B', 'C', 'D'))
);

INSERT INTO department (department_id, department_name, faculty) VALUES
('DPT001', 'Computer Science', 'Computing'),
('DPT002', 'Microbiology', 'Natural Sciences'),
('DPT003', 'Pure and Applied Biology', 'Natural Sciences'),
('DPT004', 'Biochemistry', 'Natural Sciences'),
('DPT005', 'Mathematics', 'Physical Sciences'),
('DPT006', 'Accounting', 'Management Sciences'),
('DPT007', 'Mass Communication', 'Communication Studies');

INSERT INTO student (student_id, first_name, last_name, gender, department_id, level, email) VALUES
('STU001', 'David', 'Adewale', 'Male', 'DPT001', 300, 'david@xyz.edu.ng'),
('STU002', 'Esther', 'Okafor', 'Female', 'DPT002', 200, 'esther@xyz.edu.ng'),
('STU003', 'Michael', 'Johnson', 'Male', 'DPT003', 400, 'michael@xyz.edu.ng'),
('STU004', 'Grace', 'Ibrahim', 'Female', 'DPT004', 300, 'grace@xyz.edu.ng'),
('STU005', 'Samuel', 'Bello', 'Male', 'DPT001', 200, 'samuel@xyz.edu.ng'),
('STU006', 'Favour', 'Oladipo', 'Female', 'DPT003', 200, 'favour@xyz.edu.ng'),
('STU007', 'Daniel', 'Eze', 'Male', 'DPT005', 400, 'daniel@xyz.edu.ng'),
('STU008', 'Deborah', 'Williams', 'Female', 'DPT006', 300, 'deborah@xyz.edu.ng'),
('STU009', 'Joseph', 'Musa', 'Male', 'DPT002', 400, 'joseph@xyz.edu.ng'),
('STU010', 'Peace', 'Akinola', 'Female', 'DPT007', 200, 'peace@xyz.edu.ng');

INSERT INTO lecturer (lecturer_id, first_name, last_name, email, department_id, designation) VALUES
('LEC001', 'John', 'Adeyemi', 'john@xyz.edu.ng', 'DPT001', 'Professor'),
('LEC002', 'Mary', 'Okonkwo', 'mary@xyz.edu.ng', 'DPT002', 'Senior Lecturer'),
('LEC003', 'Peter', 'Obasanjo', 'peter@xyz.edu.ng', 'DPT003', 'Lecturer I'),
('LEC004', 'Sarah', 'Ibrahim', 'sarah@xyz.edu.ng', 'DPT004', 'Senior Lecturer'),
('LEC005', 'David', 'Adebayo', 'david@xyz.edu.ng', 'DPT005', 'Lecturer II'),
('LEC006', 'Helen', 'Yusuf', 'helen@xyz.edu.ng', 'DPT006', 'Professor'),
('LEC007', 'Charles', 'Nwosu', 'charles@xyz.edu.ng', 'DPT007', 'Lecturer I'),
('LEC008', 'Esther', 'Balogun', 'estherb@xyz.edu.ng', 'DPT001', 'Senior Lecturer');

INSERT INTO course (course_id, course_code, course_title, credit_unit, department_id) VALUES
('CRS001', 'CSC301', 'Database Management Systems', 3, 'DPT001'),
('CRS002', 'CSC302', 'Computer Networks', 2, 'DPT001'),
('CRS003', 'MCB201', 'General Microbiology', 3, 'DPT002'),
('CRS004', 'MCB302', 'Medical Microbiology', 2, 'DPT002'),
('CRS005', 'BIO401', 'Plant Biotechnology', 3, 'DPT003'),
('CRS006', 'BIO302', 'Plant Physiology', 2, 'DPT003'),
('CRS007', 'BCH301', 'Enzymology', 3, 'DPT004'),
('CRS008', 'MAT401', 'Advanced Calculus', 3, 'DPT005'),
('CRS009', 'ACC301', 'Financial Accounting', 2, 'DPT006'),
('CRS010', 'MAC201', 'Media and Society', 2, 'DPT007');

INSERT INTO lecturer_course (assignment_id, lecturer_id, course_id, semester, academic_year) VALUES
('ASN001', 'LEC001', 'CRS001', 'First', '2025/2026'),
('ASN002', 'LEC008', 'CRS002', 'First', '2025/2026'),
('ASN003', 'LEC002', 'CRS003', 'First', '2025/2026'),
('ASN004', 'LEC002', 'CRS004', 'Second', '2025/2026'),
('ASN005', 'LEC003', 'CRS005', 'First', '2025/2026'),
('ASN006', 'LEC003', 'CRS006', 'Second', '2025/2026'),
('ASN007', 'LEC004', 'CRS007', 'First', '2025/2026'),
('ASN008', 'LEC005', 'CRS008', 'First', '2025/2026'),
('ASN009', 'LEC006', 'CRS009', 'Second', '2025/2026'),
('ASN010', 'LEC007', 'CRS010', 'First', '2025/2026');

INSERT INTO registration (registration_id, student_id, course_id, semester, academic_year, registration_status, score, grade) VALUES
('REG001', 'STU001', 'CRS001', 'First', '2025/2026', 'Approved', 78, 'A'),
('REG002', 'STU001', 'CRS002', 'First', '2025/2026', 'Approved', 65, 'B'),
('REG003', 'STU002', 'CRS003', 'First', '2025/2026', 'Approved', 72, 'A'),
('REG004', 'STU002', 'CRS004', 'Second', '2025/2026', 'Pending', NULL, NULL),
('REG005', 'STU003', 'CRS005', 'First', '2025/2026', 'Approved', 85, 'A'),
('REG006', 'STU003', 'CRS006', 'Second', '2025/2026', 'Approved', 69, 'B'),
('REG007', 'STU004', 'CRS007', 'First', '2025/2026', 'Approved', 58, 'C'),
('REG008', 'STU005', 'CRS001', 'First', '2025/2026', 'Approved', 62, 'B'),
('REG009', 'STU005', 'CRS002', 'First', '2025/2026', 'Approved', 48, 'D'),
('REG010', 'STU006', 'CRS005', 'First', '2025/2026', 'Approved', 76, 'A'),
('REG011', 'STU007', 'CRS008', 'First', '2025/2026', 'Approved', 81, 'A'),
('REG012', 'STU008', 'CRS009', 'Second', '2025/2026', 'Approved', 67, 'B'),
('REG013', 'STU009', 'CRS003', 'First', '2025/2026', 'Approved', 55, 'C'),
('REG014', 'STU010', 'CRS010', 'First', '2025/2026', 'Approved', 73, 'A');
