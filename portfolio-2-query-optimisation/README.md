# Portfolio 2: Query Processing and Optimisation

## Purpose

This portfolio focuses on how the relational database handles common academic queries, how the query planner chooses execution strategies, and how indexing changes performance.

The main tasks are:

- write useful SQL queries against the student results schema
- execute them and review the output
- compare query plans before and after indexing
- explain why the chosen plan is efficient or inefficient

## Example database queries

Use the same entity structure created in Portfolio 1.

### Query 1: Students in a department

```sql
SELECT s.student_number, s.first_name, s.last_name, d.department_name
FROM student s
JOIN department d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science'
ORDER BY s.last_name;
```

Purpose: shows how to retrieve students by department.

### Query 2: Students and their grades by course

```sql
SELECT s.student_number, s.first_name, s.last_name,
       c.course_code, c.course_title, r.grade
FROM registration r
JOIN student s ON r.student_id = s.student_id
JOIN course c ON r.course_id = c.course_id
ORDER BY s.last_name, c.course_code;
```

Purpose: reports student results across registered courses.

### Query 3: Students who failed a course

```sql
SELECT s.student_number, s.first_name, s.last_name,
       c.course_code, c.course_title, r.grade
FROM registration r
JOIN student s ON r.student_id = s.student_id
JOIN course c ON r.course_id = c.course_id
WHERE r.grade IN ('F', 'E', 'D')
ORDER BY s.last_name;
```

Purpose: identifies academic risk or intervention candidates.

### Query 4: Lecturer workload

```sql
SELECT l.lecturer_number, l.first_name, l.last_name,
       COUNT(ca.course_id) AS courses_taught
FROM lecturer l
LEFT JOIN course_assignment ca ON l.lecturer_id = ca.lecturer_id
GROUP BY l.lecturer_number, l.first_name, l.last_name
ORDER BY courses_taught DESC, l.last_name;
```

Purpose: shows how many courses each lecturer teaches.

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

Purpose: summarises performance in each course.

## Query plan and optimisation example

The database planner chooses a strategy based on table size, indexes and search conditions. A repeated filter such as `WHERE department_id = ...` benefits from an index.

Example of a plan before indexing:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM student
WHERE department_id = 1;
```

Example after adding an index:

```sql
CREATE INDEX idx_student_department_id
ON student (department_id);

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM student
WHERE department_id = 1;
```

Expected improvement:

- Before index: full scan or larger sequential read
- After index: index scan or index-only scan, with fewer buffer reads

## Suggested optimisation indexes

```sql
CREATE INDEX idx_registration_student_id
ON registration (student_id);

CREATE INDEX idx_registration_course_id
ON registration (course_id);

CREATE INDEX idx_registration_grade
ON registration (grade);

CREATE INDEX idx_course_department_id
ON course (department_id);

CREATE INDEX idx_student_department_id
ON student (department_id);
```

## Performance analysis guidance

When writing your final explanation:

- compare query time before and after the index
- explain whether PostgreSQL changed from a sequential scan to an index scan
- mention buffer usage and reduced read cost
- keep the discussion realistic: indexes improve certain filters but add storage and maintenance overhead

## Portfolio 2 evidence to save

Include the following in your final documentation:

- SQL query script with actual results
- `EXPLAIN (ANALYZE, BUFFERS)` output before and after index creation
- a short comparison table of timing differences
- a paragraph explaining the cause of the performance change

## Example comparison table

| Query type | Before index | After index | Observation |
| --- | --- | --- | --- |
| Filter by department | Seq Scan | Index Scan | Faster lookup for department-based reports |
| Join with registration | Hash Join / Seq Scan | Nested Loop / Index Scan | Better when the foreign key is indexed |

## Portfolio 2 submission checklist

- [ ] Queries run and results captured
- [ ] Execution plans saved
- [ ] Index created and compared
- [ ] Measured performance discussed
- [ ] Final explanation written clearly in your own words

