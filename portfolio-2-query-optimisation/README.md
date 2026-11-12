# Portfolio 2: Query Processing and Optimisation

## Purpose

This portfolio focuses on how the relational database handles common academic queries, how the query planner chooses execution strategies, and how indexing changes performance for the XYZ University Student Results Portal.

## Case study data used

The database stores the following academic records:

- Departments: 7
- Students: 10
- Lecturers: 8
- Courses: 10
- Lecturer assignments: 10
- Student registrations: 14

The relational design is based on the Department, Student, Lecturer, Course, Lecturer_Course, and Registration tables described in Portfolio 1.

## Example database queries

### Query 1: Students in a department

```sql
SELECT s.student_id, s.first_name, s.last_name, d.department_name
FROM student s
JOIN department d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science'
ORDER BY s.last_name;
```

Purpose: retrieve all students in a particular department.

### Query 2: Student academic results by course

```sql
SELECT s.student_id, s.first_name, s.last_name,
       c.course_code, c.course_title, r.grade, r.score
FROM registration r
JOIN student s ON r.student_id = s.student_id
JOIN course c ON r.course_id = c.course_id
ORDER BY s.last_name, c.course_code;
```

Purpose: show results for each course registration.

### Query 3: Students with failing grades

```sql
SELECT s.student_id, s.first_name, s.last_name,
       c.course_code, c.course_title, r.score, r.grade
FROM registration r
JOIN student s ON r.student_id = s.student_id
JOIN course c ON r.course_id = c.course_id
WHERE r.grade IN ('D')
ORDER BY s.last_name;
```

Purpose: identify students with low academic performance.

### Query 4: Lecturer workload

```sql
SELECT l.lecturer_id, l.first_name, l.last_name,
       COUNT(lc.course_id) AS courses_assigned
FROM lecturer l
LEFT JOIN lecturer_course lc ON l.lecturer_id = lc.lecturer_id
GROUP BY l.lecturer_id, l.first_name, l.last_name
ORDER BY courses_assigned DESC, l.last_name;
```

Purpose: show how many courses each lecturer teaches.

### Query 5: Average grade by course

```sql
SELECT c.course_code, c.course_title,
       ROUND(AVG(CASE
           WHEN r.grade = 'A' THEN 4.0
           WHEN r.grade = 'B' THEN 3.0
           WHEN r.grade = 'C' THEN 2.0
           WHEN r.grade = 'D' THEN 1.0
           ELSE 0.0
       END), 2) AS average_grade_point
FROM course c
LEFT JOIN registration r ON c.course_id = r.course_id
GROUP BY c.course_code, c.course_title
ORDER BY average_grade_point DESC;
```

Purpose: evaluate academic performance by course.

## Query plan and optimisation example

The database planner selects an execution strategy based on table size, indexes, and search conditions. A query filtering on department or student_id can improve significantly when an index is available.

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM student
WHERE department_id = 'DPT001';
```

After adding an index:

```sql
CREATE INDEX idx_student_department_id
ON student (department_id);

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM student
WHERE department_id = 'DPT001';
```

## Useful indexes for this database

```sql
CREATE INDEX idx_registration_student_id
ON registration (student_id);

CREATE INDEX idx_registration_course_id
ON registration (course_id);

CREATE INDEX idx_course_department_id
ON course (department_id);

CREATE INDEX idx_lecturer_department_id
ON lecturer (department_id);
```

## Why indexing matters

Without indexes, the database may scan many rows when answering common academic queries. Indexes reduce the number of records examined, which improves efficiency and response time during registration checks, grade reporting, and department summaries.

## Conclusion

The XYZ University database is suitable for relational queries because it contains clearly defined relationships, predictable data structures, and many reporting tasks. Indexing plays a major role in ensuring that queries such as student search, lecturer workload, and course performance analysis run efficiently even as the database grows.
