-- Portfolio 1: Database design and sample schema
-- Case study: XYZ University Student Results Portal

DROP TABLE IF EXISTS registration CASCADE;
DROP TABLE IF EXISTS course_assignment CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS lecturer CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS department CASCADE;

CREATE TABLE department (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_code VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    student_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE,
    department_id INT NOT NULL,
    admission_year INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE lecturer (
    lecturer_id SERIAL PRIMARY KEY,
    lecturer_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE course (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_title VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE course_assignment (
    course_id INT NOT NULL,
    lecturer_id INT NOT NULL,
    PRIMARY KEY (course_id, lecturer_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (lecturer_id) REFERENCES lecturer(lecturer_id)
);

CREATE TABLE registration (
    registration_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    grade VARCHAR(5),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    registered_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_id, course_id, semester, academic_year),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    CHECK (grade IN ('A', 'B', 'C', 'D', 'E', 'F', 'W', 'WA', 'I'))
);

-- Example sample data
INSERT INTO department (department_name, department_code)
VALUES
    ('Computer Science', 'CS'),
    ('Business Administration', 'BA'),
    ('Accounting', 'ACC');

INSERT INTO student (student_number, first_name, last_name, email, date_of_birth, department_id, admission_year)
VALUES
    ('S001', 'Amaka', 'Okafor', 'amaka.okafor@xyz.edu', '2002-04-12', 1, 2022),
    ('S002', 'Tobi', 'Adebayo', 'tobi.adebayo@xyz.edu', '2001-09-19', 1, 2021),
    ('S003', 'Grace', 'Mensah', 'grace.mensah@xyz.edu', '2003-02-08', 2, 2023),
    ('S004', 'Daniel', 'Ifeanyi', 'daniel.ifeanyi@xyz.edu', '2002-11-04', 3, 2022);

INSERT INTO lecturer (lecturer_number, first_name, last_name, email, department_id)
VALUES
    ('L001', 'Michael', 'Johnson', 'michael.johnson@xyz.edu', 1),
    ('L002', 'Sarah', 'Akin', 'sarah.akin@xyz.edu', 1),
    ('L003', 'Ngozi', 'Eze', 'ngozi.eze@xyz.edu', 2),
    ('L004', 'Kofi', 'Boateng', 'kofi.boateng@xyz.edu', 3);

INSERT INTO course (course_code, course_title, credits, department_id)
VALUES
    ('CS101', 'Introduction to Programming', 3, 1),
    ('CS201', 'Database Systems', 3, 1),
    ('BA101', 'Principles of Management', 3, 2),
    ('ACC201', 'Financial Accounting', 3, 3);

INSERT INTO course_assignment (course_id, lecturer_id)
VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 3),
    (4, 4);

INSERT INTO registration (student_id, course_id, semester, academic_year, grade, status)
VALUES
    (1, 1, 'Semester 1', '2022/2023', 'A', 'COMPLETED'),
    (1, 2, 'Semester 2', '2022/2023', 'B', 'COMPLETED'),
    (2, 1, 'Semester 1', '2022/2023', 'C', 'COMPLETED'),
    (2, 2, 'Semester 2', '2022/2023', 'A', 'COMPLETED'),
    (3, 3, 'Semester 1', '2023/2024', 'B', 'COMPLETED'),
    (4, 4, 'Semester 2', '2023/2024', 'A', 'COMPLETED');

SELECT * FROM department;
SELECT * FROM student;
SELECT * FROM course;
SELECT * FROM registration;
