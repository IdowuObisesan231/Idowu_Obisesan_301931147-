-- Portfolio 2: Example SQL queries for XYZ University database

-- Query 1: Students in a department
SELECT s.student_id, s.first_name, s.last_name, d.department_name
FROM student s
JOIN department d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science'
ORDER BY s.last_name;

-- Query 2: Student results by course
SELECT s.student_id, s.first_name, s.last_name,
       c.course_code, c.course_title, r.grade, r.score
FROM registration r
JOIN student s ON r.student_id = s.student_id
JOIN course c ON r.course_id = c.course_id
ORDER BY s.last_name, c.course_code;

-- Query 3: Students with low grades
SELECT s.student_id, s.first_name, s.last_name,
       c.course_code, c.course_title, r.score, r.grade
FROM registration r
JOIN student s ON r.student_id = s.student_id
JOIN course c ON r.course_id = c.course_id
WHERE r.grade IN ('D')
ORDER BY s.last_name;

-- Query 4: Lecturer workload
SELECT l.lecturer_id, l.first_name, l.last_name,
       COUNT(lc.course_id) AS courses_assigned
FROM lecturer l
LEFT JOIN lecturer_course lc ON l.lecturer_id = lc.lecturer_id
GROUP BY l.lecturer_id, l.first_name, l.last_name
ORDER BY courses_assigned DESC, l.last_name;

-- Query 5: Average grade by course
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

-- Query plan before index
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM student
WHERE department_id = 'DPT001';

-- Add index for performance comparison
CREATE INDEX idx_student_department_id
ON student (department_id);

-- Query plan after index
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM student
WHERE department_id = 'DPT001';

-- Additional useful indexes
CREATE INDEX idx_registration_student_id
ON registration (student_id);

CREATE INDEX idx_registration_course_id
ON registration (course_id);

CREATE INDEX idx_course_department_id
ON course (department_id);

CREATE INDEX idx_lecturer_department_id
ON lecturer (department_id);
