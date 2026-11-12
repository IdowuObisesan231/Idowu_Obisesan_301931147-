# Portfolio 1: Database Design and Modelling

## Project Title

Design and Implementation of a Relational Database Management System for XYZ University.

**Institution:** XYZ University, Nigeria  
**Academic Session:** 2025/2026

## 1. Department Table

This table contains the various academic departments in XYZ University.

| Department_ID | Department_Name | Faculty |
| --- | --- | --- |
| DPT001 | Computer Science | Computing |
| DPT002 | Microbiology | Natural Sciences |
| DPT003 | Pure and Applied Biology | Natural Sciences |
| DPT004 | Biochemistry | Natural Sciences |
| DPT005 | Mathematics | Physical Sciences |
| DPT006 | Accounting | Management Sciences |
| DPT007 | Mass Communication | Communication Studies |

## 2. Student Table

This table stores the personal and academic information of registered students.

| Student_ID | First_Name | Last_Name | Gender | Department_ID | Level | Email |
| --- | --- | --- | --- | --- | --- | --- |
| STU001 | David | Adewale | Male | DPT001 | 300 | david@xyz.edu.ng |
| STU002 | Esther | Okafor | Female | DPT002 | 200 | esther@xyz.edu.ng |
| STU003 | Michael | Johnson | Male | DPT003 | 400 | michael@xyz.edu.ng |
| STU004 | Grace | Ibrahim | Female | DPT004 | 300 | grace@xyz.edu.ng |
| STU005 | Samuel | Bello | Male | DPT001 | 200 | samuel@xyz.edu.ng |
| STU006 | Favour | Oladipo | Female | DPT003 | 200 | favour@xyz.edu.ng |
| STU007 | Daniel | Eze | Male | DPT005 | 400 | daniel@xyz.edu.ng |
| STU008 | Deborah | Williams | Female | DPT006 | 300 | deborah@xyz.edu.ng |
| STU009 | Joseph | Musa | Male | DPT002 | 400 | joseph@xyz.edu.ng |
| STU010 | Peace | Akinola | Female | DPT007 | 200 | peace@xyz.edu.ng |

## 3. Lecturer Table

This table maintains information about academic staff members.

| Lecturer_ID | First_Name | Last_Name | Email | Department_ID | Designation |
| --- | --- | --- | --- | --- | --- |
| LEC001 | John | Adeyemi | john@xyz.edu.ng | DPT001 | Professor |
| LEC002 | Mary | Okonkwo | mary@xyz.edu.ng | DPT002 | Senior Lecturer |
| LEC003 | Peter | Obasanjo | peter@xyz.edu.ng | DPT003 | Lecturer I |
| LEC004 | Sarah | Ibrahim | sarah@xyz.edu.ng | DPT004 | Senior Lecturer |
| LEC005 | David | Adebayo | david@xyz.edu.ng | DPT005 | Lecturer II |
| LEC006 | Helen | Yusuf | helen@xyz.edu.ng | DPT006 | Professor |
| LEC007 | Charles | Nwosu | charles@xyz.edu.ng | DPT007 | Lecturer I |
| LEC008 | Esther | Balogun | estherb@xyz.edu.ng | DPT001 | Senior Lecturer |

## 4. Course Table

This table contains the courses offered by the different departments.

| Course_ID | Course_Code | Course_Title | Credit_Unit | Department_ID |
| --- | --- | --- | --- | --- |
| CRS001 | CSC301 | Database Management Systems | 3 | DPT001 |
| CRS002 | CSC302 | Computer Networks | 2 | DPT001 |
| CRS003 | MCB201 | General Microbiology | 3 | DPT002 |
| CRS004 | MCB302 | Medical Microbiology | 2 | DPT002 |
| CRS005 | BIO401 | Plant Biotechnology | 3 | DPT003 |
| CRS006 | BIO302 | Plant Physiology | 2 | DPT003 |
| CRS007 | BCH301 | Enzymology | 3 | DPT004 |
| CRS008 | MAT401 | Advanced Calculus | 3 | DPT005 |
| CRS009 | ACC301 | Financial Accounting | 2 | DPT006 |
| CRS010 | MAC201 | Media and Society | 2 | DPT007 |

## 5. Lecturer_Course Table

This table records which lecturers are assigned to teach particular courses. It resolves the many-to-many relationship between lecturers and courses.

| Assignment_ID | Lecturer_ID | Course_ID | Semester | Academic_Year |
| --- | --- | --- | --- | --- |
| ASN001 | LEC001 | CRS001 | First | 2025/2026 |
| ASN002 | LEC008 | CRS002 | First | 2025/2026 |
| ASN003 | LEC002 | CRS003 | First | 2025/2026 |
| ASN004 | LEC002 | CRS004 | Second | 2025/2026 |
| ASN005 | LEC003 | CRS005 | First | 2025/2026 |
| ASN006 | LEC003 | CRS006 | Second | 2025/2026 |
| ASN007 | LEC004 | CRS007 | First | 2025/2026 |
| ASN008 | LEC005 | CRS008 | First | 2025/2026 |
| ASN009 | LEC006 | CRS009 | Second | 2025/2026 |
| ASN010 | LEC007 | CRS010 | First | 2025/2026 |

## 6. Registration Table

This table records students' course enrolments, registration status, and academic results.

| Registration_ID | Student_ID | Course_ID | Semester | Academic_Year | Registration_Status | Score | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| REG001 | STU001 | CRS001 | First | 2025/2026 | Approved | 78 | A |
| REG002 | STU001 | CRS002 | First | 2025/2026 | Approved | 65 | B |
| REG003 | STU002 | CRS003 | First | 2025/2026 | Approved | 72 | A |
| REG004 | STU002 | CRS004 | Second | 2025/2026 | Pending | NULL | NULL |
| REG005 | STU003 | CRS005 | First | 2025/2026 | Approved | 85 | A |
| REG006 | STU003 | CRS006 | Second | 2025/2026 | Approved | 69 | B |
| REG007 | STU004 | CRS007 | First | 2025/2026 | Approved | 58 | C |
| REG008 | STU005 | CRS001 | First | 2025/2026 | Approved | 62 | B |
| REG009 | STU005 | CRS002 | First | 2025/2026 | Approved | 48 | D |
| REG010 | STU006 | CRS005 | First | 2025/2026 | Approved | 76 | A |
| REG011 | STU007 | CRS008 | First | 2025/2026 | Approved | 81 | A |
| REG012 | STU008 | CRS009 | Second | 2025/2026 | Approved | 67 | B |
| REG013 | STU009 | CRS003 | First | 2025/2026 | Approved | 55 | C |
| REG014 | STU010 | CRS010 | First | 2025/2026 | Approved | 73 | A |

## 7. Summary of the Database

The proposed XYZ University database contains six relational tables.

| Table | Number of Records | Primary Key |
| --- | --- | --- |
| Department | 7 | Department_ID |
| Student | 10 | Student_ID |
| Lecturer | 8 | Lecturer_ID |
| Course | 10 | Course_ID |
| Lecturer_Course | 10 | Assignment_ID |
| Registration | 14 | Registration_ID |
| Total | 59 |  |

## 8. Database Relationships

The tables are connected through primary and foreign keys as follows:

1. Department – Student: One department can have many students.
2. Department – Lecturer: One department can employ many lecturers.
3. Department – Course: One department can offer many courses.
4. Lecturer – Course: Many-to-many relationship, resolved through the Lecturer_Course table.
5. Student – Course: Many-to-many relationship, resolved through the Registration table.
6. Course – Registration: One course can have many student registrations.
7. Student – Registration: One student can register for many courses.

## 9. Example Database Queries for the Assignment

The hypothetical data can be used to demonstrate the following SQL operations on GitHub.

| Administrative Task | SQL Operation |
| --- | --- |
| View all registered students | SELECT |
| Find students in a particular department | SELECT with WHERE |
| View a student's academic results | SELECT with JOIN |
| List all students registered for CSC301 | SELECT with JOIN |
| Identify lecturers teaching each course | SELECT with JOIN |
| Count students in each department | GROUP BY and COUNT |
| Identify courses without registrations | LEFT JOIN |
| Update a student's registration status | UPDATE |
| Add a new student record | INSERT |
| Remove an invalid registration | DELETE |

## 10. Important Database Design Considerations

For the Advanced Database Management System assignment, consider implementing these constraints:

- Primary Key: Every table must have a unique primary key.
- Foreign Key: Ensure that student, lecturer, department, and course records maintain referential integrity.
- Unique Constraint: Student email, lecturer email, and course code should be unique.
- NOT NULL: Essential fields such as student name, department ID, and course title should not be empty.
- CHECK Constraint: Credit units and examination scores should fall within acceptable ranges.
- Composite Uniqueness: A student should not register for the same course twice in the same semester and academic year.

## Normalisation and ER Model Summary

The database design follows the normalisation rules needed for a relational academic system.

### 1NF

Each table stores atomic values. A registration row represents one student-course record for a semester and year, rather than storing repeated values in a single field.

### 2NF

Every non-key attribute depends on the full primary key. Student and course details are kept in separate tables so they are not repeated in registration rows.

### 3NF

No non-key attribute depends on another non-key attribute. Department names, course titles, and lecturer information are stored once and referenced by foreign keys.

## Conclusion

This relational database design satisfies the assignment requirements by modelling the university domain with clear entities, relationships, constraints, and academic tracking features. It promotes data integrity, reduces redundancy, and supports meaningful SQL queries for reporting and academic management.
