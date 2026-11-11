# Portfolio 3: Transactions and Concurrency

## Purpose

This portfolio focuses on how the XYZ University Student Results Portal handles database transactions, concurrency control, and isolation guarantees. The goal is to show how the system preserves data integrity when multiple users perform academic operations at the same time.

The main tasks are:

- explain the transaction rules for student registration and grading
- show how SQL transactions maintain atomicity and consistency
- demonstrate concurrency issues such as lost updates and duplicate registrations
- explain how isolation levels and locking reduce conflict
- document evidence collected from transaction execution

## Case study transaction scenarios

The university system must support several high-value transactions:

1. A student registers for a course in a given semester.
2. A lecturer assigns or updates a final grade.
3. A department reviews grade changes for a subject.
4. A student or lecturer reads academic results while other updates are happening.

These activities must obey the database's integrity rules and remain reliable under simultaneous access.

## ACID properties

Database transactions should obey ACID properties:

- Atomicity: all statements in a transaction succeed or none do.
- Consistency: the database remains in a valid state after a transaction finishes.
- Isolation: concurrent transactions do not interfere with one another unexpectedly.
- Durability: committed changes persist even if the system fails later.

In this portfolio, the most important examples are related to registration and grade updates.

## Example transaction: student course registration

A student should be allowed to register for a course only once in a semester. The transaction must ensure that the registration record is inserted only if the rule is satisfied.

```sql
BEGIN;

INSERT INTO registration (student_id, course_id, semester, academic_year, status)
SELECT s.student_id, c.course_id, '2026/2027 Sem 1', '2026/2027', 'ACTIVE'
FROM student s
JOIN course c ON c.course_code = 'CS101'
WHERE s.student_number = '20240001'
ON CONFLICT (student_id, course_id, semester, academic_year) DO NOTHING;

-- Confirm if the row was created
SELECT *
FROM registration
WHERE student_id = (
    SELECT student_id FROM student WHERE student_number = '20240001'
)
AND course_id = (
    SELECT course_id FROM course WHERE course_code = 'CS101'
)
AND semester = '2026/2027 Sem 1';

COMMIT;
```

### Purpose

This transaction ensures that duplicate registrations are blocked, and the final state remains valid. If a duplicate exists, the `ON CONFLICT ... DO NOTHING` clause prevents a second row from being inserted.

## Example transaction: grade update

A lecturer may update a student grade after a final exam. The database should preserve consistency and make sure that only valid grade values are stored.

```sql
BEGIN;

UPDATE registration
SET grade = 'B', status = 'COMPLETED'
WHERE student_id = (
    SELECT student_id FROM student WHERE student_number = '20240001'
)
AND course_id = (
    SELECT course_id FROM course WHERE course_code = 'CS101'
)
AND semester = '2026/2027 Sem 1';

SELECT student_number, course_code, grade, status
FROM registration r
JOIN student s ON s.student_id = r.student_id
JOIN course c ON c.course_id = r.course_id
WHERE s.student_number = '20240001'
AND c.course_code = 'CS101';

COMMIT;
```

### Why this is important

A grade update changes the academic record, so the transaction must complete atomically. If the system fails halfway through, the database should either keep the old value or commit the full change, but never a partial result.

## Transaction rollback example

A rollback is useful when validation fails before a transaction is accepted.

```sql
BEGIN;

UPDATE registration
SET grade = 'X'
WHERE student_id = 101
AND course_id = 20;

-- This would violate the CHECK constraint on grade.
-- PostgreSQL raises an error and the transaction is cancelled.
ROLLBACK;
```

Expected result:

- the `UPDATE` fails because the grade value is invalid
- the transaction is rolled back
- no partial changes remain

## Concurrency problems in the student system

The database may face concurrent transactions when students and lecturers act at the same time.

### 1. Duplicate registration race

Two students or two sessions may both try to register the same student for the same course at the same time.

Without proper control, both transactions may read the same state before either insert is committed. This can lead to duplicate registration rows or inconsistent results.

### 2. Lost update

Two lecturers may try to update the same student's grade at the same time.

For example:

- Transaction A updates the grade from `C` to `B`
- Transaction B updates the same grade from `C` to `A`

If both transactions are not isolated properly, one update may overwrite the other.

### 3. Read inconsistency

A department may run a report while a grade update is in progress. If the read is not properly isolated, the report may show a mix of old and new values.

## Isolation levels

PostgreSQL supports several isolation levels. The most relevant ones for this case study are:

- Read Committed: default mode; each query sees committed data at the time the query starts.
- Repeatable Read: prevents non-repeatable reads within a transaction.
- Serializable: strongest guarantee; useful when many concurrent transactions modify the same records.

Example:

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;

SELECT *
FROM registration
WHERE student_id = 101;

-- The selected rows are protected from conflicting updates until the transaction ends.
COMMIT;
```

## Locking and concurrency control

The database uses locking to maintain consistency.

- Row-level locks protect specific registration records while they are being updated.
- Table-level locks are used sparingly and usually for large structural changes.
- Indexes, especially on `student_id`, `course_id`, and `semester`, help reduce the number of rows that must be locked.

### Example locking behaviour

```sql
BEGIN;

SELECT *
FROM registration
WHERE student_id = 101
FOR UPDATE;

-- This locks the selected registration rows so another transaction cannot change them until this one ends.

UPDATE registration
SET grade = 'A'
WHERE student_id = 101
AND course_id = 7;

COMMIT;
```

This pattern is useful when a lecturer needs to guarantee exclusive access while assigning a grade.

## Suggested SQL scripts

Use the following files in your final submission:

- `transactions.sql` — example transactions and locking scripts
- `concurrency_validation.sql` — examples of race-condition checks and isolation behaviour

## Example performance/concurrency evidence table

| Scenario | Transaction action | Expected outcome | Reason |
| --- | --- | --- | --- |
| Duplicate registration | Two inserts for same student/course/semester | Only one row remains | Unique constraint and transaction guard |
| Grade update | Lecturer updates grade | Record is updated atomically | ACID transaction and row lock |
| Concurrent reads | Reporting while grade change occurs | Consistent results | Isolation level controls visibility |
| Locking during update | `SELECT ... FOR UPDATE` | Other updates wait | Prevents lost updates |

## Evidence to include in the final portfolio

The final report should include:

- the SQL transaction script used for registration and grade updates
- a short example of a failed transaction and rollback
- explain at least one concurrency issue and how it was prevented
- show how `SELECT ... FOR UPDATE` or isolation settings help maintain consistency
- discuss why transactions are necessary in academic records

## Portfolio 3 submission checklist

- [ ] Transaction purpose and business rules written clearly
- [ ] SQL examples for registration and grade updates included
- [ ] Rollback example shown and explained
- [ ] Concurrency issue identified and discussed
- [ ] Isolation or locking strategy explained
- [ ] Final explanation written in your own words

## Suggested conclusion

Transactions and concurrency control are essential in a university student results system because academic records must remain accurate and trustworthy even when many users access the database simultaneously. The design ensures that duplicate registrations are blocked, final grades are preserved correctly, and concurrent activity does not corrupt the system.

This portfolio demonstrates how SQL transactions, constraints, and isolation mechanisms work together to protect the integrity of the student records database.

---

This file is part of the MIT 8103 Advanced Database Systems portfolio for the XYZ University Student Results Portal case study.
