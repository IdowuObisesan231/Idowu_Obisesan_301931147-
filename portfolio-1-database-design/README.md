# Portfolio 1: Database Design and Modelling

## Case study

XYZ University Student Results Portal is a system for recording student records, academic programmes, course offerings, lecturer assignments and final grades. The database must support course registration, grade tracking, academic reporting, and department-level analysis.

The main entities in the case study are:

- Student
- Department
- Course
- Lecturer
- Registration / Grade Record

## Business rules

1. Each student belongs to exactly one department.
2. Each course belongs to exactly one department.
3. A lecturer belongs to one department.
4. A course may be taught by one or more lecturers.
5. A student can register for many courses, and each course can have many students.
6. One student may register for the same course only once in a given semester.
7. Each registration record stores the semester and final grade for that course.
8. A grade must be one of the allowed academic results (A, B, C, D, E, F, W, etc., according to institutional policy).

## Conceptual data model

This case study naturally follows a relational model with a set of related tables. The main relationships are:

- Department to Student: one-to-many
- Department to Course: one-to-many
- Department to Lecturer: one-to-many
- Student to Course via Registration: many-to-many
- Lecturer to Course via Course Assignment: many-to-many

## Relational schema

```sql
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
```

## Key constraints

- Primary keys identify each row uniquely.
- Foreign keys enforce valid relationships between tables.
- UNIQUE constraints prevent duplicate student numbers, course codes and registrations.
- CHECK constraints restrict invalid values such as negative credits and invalid grade codes.
- NOT NULL constraints enforce required data entry.

## ER diagram overview

The ER model can be described as:

- Department has many Students, Lecturers and Courses.
- Student registers for many Courses through the Registration table.
- Course is taught by many Lecturers through the Course Assignment table.
- Registration records the semester, academic year and grade for each student-course pair.

A suitable ER diagram should show the following cardinalities:

- Department 1 — N Student
- Department 1 — N Lecturer
- Department 1 — N Course
- Student N — N Course through Registration
- Lecturer N — N Course through course_assignment

## Normalisation explanation

### 1NF

A table is in first normal form if each column contains atomic values and each row is unique. For example, the registration table stores one row per student-course-semester combination. Each grade is stored in a single column rather than as a list or repeated fields.

Example:

- Before: `student_id = 101, grades = 'A, B, C'`
- After: one row per course registration, with separate values in `course_id` and `grade`.

### 2NF

A table is in 2NF if it is in 1NF and all non-key attributes depend on the whole primary key. In the registration table, attributes such as `grade`, `semester` and `status` depend on the full registration key, not on just one column. The student and course details are kept in their own tables instead of repeating them in registration rows.

### 3NF

A table is in 3NF if it is in 2NF and all non-key attributes depend only on the primary key and not on other non-key attributes. For example:

- `student` stores student details only; it does not repeat department name.
- `course` stores course title and credits only; it does not duplicate lecturer details.
- Department name is stored once in `department`.

This reduces update anomalies and ensures clean, consistent data.

## Why this schema is suitable

The design supports the assignment requirements:

- It captures all core entities in the case study.
- It enforces data validity through constraints.
- It handles many-to-many relationships cleanly.
- It supports queries for student performance, department analysis, course workload and lecturer assignments.

## Evidence to include in the final portfolio

You should include:

- ER diagram image or textual relationship model
- SQL schema creation script
- Sample insert statements
- A short validation showing created rows and constraints working
- A paragraph explaining the design and normalisation choices

## Suggested file names

- `schema.sql`
- `sample_data.sql`
- `portfolio_1_validation.sql`

Use actual outputs from PostgreSQL to support your explanations.

## Portfolio 1 submission checklist

- [ ] case study description written clearly
- [ ] ER diagram included
- [ ] schema and keys explained
- [ ] normalisation examples included
- [ ] constraints and validation evidence saved
- [ ] final explanation written in your own words

