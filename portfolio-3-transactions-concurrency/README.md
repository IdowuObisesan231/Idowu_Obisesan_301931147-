# Portfolio 3: Transactions and Concurrency

## Purpose

This portfolio demonstrates how transactional control protects the integrity of the XYZ University database during registration and grading processes. In a university system, academic records must remain correct even when multiple users access them at the same time.

## Transaction requirements for the case study

The system must maintain the following rules:

- A student cannot register for the same course more than once in the same semester and academic year.
- A lecturer must update a grade only when the registration record exists.
- Final academic records must be stored consistently and not be partially updated.
- Concurrent reads and writes must not produce inconsistent or conflicting records.

## Example transaction: registering a student for a course

```sql
BEGIN;

INSERT INTO registration (
    registration_id, student_id, course_id, semester, academic_year,
    registration_status, score, grade
)
VALUES (
    'REG015', 'STU006', 'CRS003', 'First', '2025/2026', 'Approved', 74, 'A'
);

COMMIT;
```

This transaction ensures that a new registration record is written atomically.

## Example transaction: updating a grade

```sql
BEGIN;

UPDATE registration
SET score = 80,
    grade = 'A'
WHERE student_id = 'STU001'
  AND course_id = 'CRS001'
  AND semester = 'First'
  AND academic_year = '2025/2026';

COMMIT;
```

This operation changes the academic result for a single student-course record while preserving consistency.

## Example transaction rollback

```sql
BEGIN;

UPDATE registration
SET score = 95,
    grade = 'A'
WHERE student_id = 'STU005'
  AND course_id = 'CRS002';

ROLLBACK;
```

The rollback ensures that a failed or unintended update does not leave invalid or inconsistent data in the database.

## Locking and concurrency control

The database uses locking to maintain consistency when multiple users update academic records at the same time.

```sql
BEGIN;

SELECT *
FROM registration
WHERE student_id = 'STU001' AND course_id = 'CRS001'
FOR UPDATE;

UPDATE registration
SET score = 82,
    grade = 'A'
WHERE student_id = 'STU001'
  AND course_id = 'CRS001';

COMMIT;
```

The `FOR UPDATE` clause locks the selected row so another transaction cannot modify it until the current transaction completes.

## Isolation levels

A university system may use transaction isolation to prevent inconsistent reports during grade updates. For example:

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;

SELECT *
FROM registration
WHERE student_id = 'STU003';

COMMIT;
```

Serializable isolation is useful when there are many simultaneous operations involving academic records, because it gives stronger consistency guarantees.

## Concurrency issue to prevent

A serious issue in an academic database is the lost update problem. If two lecturers attempt to update the same student's grade at the same time, one change may overwrite the other. Locking and transaction control prevent this from happening.

## Conclusion

Transactions and concurrency control are essential in a university results system because academic records must remain accurate and trustworthy even when many users access the database simultaneously. The design protects against duplicate registrations, lost updates, and invalid record changes while preserving the integrity of the student records.
