# Portfolio 4: NoSQL and Advanced Data Models

## Purpose

This portfolio examines whether a NoSQL document model is suitable for the XYZ University Student Results Portal. The assignment uses the same relational academic data but considers whether a document-based design could improve flexibility for profile-heavy and nested data access.

## Relational data used in the case study

The core system data includes:

- 7 departments
- 10 students
- 8 lecturers
- 10 courses
- 10 lecturer-course assignments
- 14 student registrations

A NoSQL approach can store student academic information in a single document with nested registration details.

## Example NoSQL document model

```json
{
  "student_id": "STU001",
  "first_name": "David",
  "last_name": "Adewale",
  "gender": "Male",
  "department_id": "DPT001",
  "department_name": "Computer Science",
  "level": 300,
  "email": "david@xyz.edu.ng",
  "registrations": [
    {
      "course_id": "CRS001",
      "course_code": "CSC301",
      "course_title": "Database Management Systems",
      "semester": "First",
      "academic_year": "2025/2026",
      "registration_status": "Approved",
      "score": 78,
      "grade": "A"
    },
    {
      "course_id": "CRS002",
      "course_code": "CSC302",
      "course_title": "Computer Networks",
      "semester": "First",
      "academic_year": "2025/2026",
      "registration_status": "Approved",
      "score": 65,
      "grade": "B"
    }
  ]
}
```

## Example MongoDB queries

### 1. Find all students in Computer Science

```javascript
db.students.find({ department_name: 'Computer Science' })
```

### 2. Find students with grade A

```javascript
db.students.find({ 'registrations.grade': 'A' })
```

### 3. Count students by department

```javascript
db.students.aggregate([
  { $group: { _id: '$department_name', count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

### 4. List all registrations for a student

```javascript
db.students.find(
  { student_id: 'STU001' },
  { registrations: 1 }
)
```

## When NoSQL is suitable

NoSQL is particularly suitable when:

- student and academic records are nested and document-like
- academic data changes frequently over time
- the system requires flexible profile retrieval
- many read-heavy queries are expected
- schema changes need to happen quickly without major redesign

## When relational databases remain better

The relational model is still preferred when:

- strong transaction integrity is required
- the database must enforce foreign keys and academic constraints
- complex multi-table reporting is common
- results and registration data must remain highly consistent

## Recommendation

For the XYZ University system, the best practical design is hybrid: use a relational database for the transactional core and a NoSQL document store for student profile summaries, nested academic records, and search-friendly read access.

## Conclusion

NoSQL is not a replacement for the relational model in every case, but it can be valuable for flexible, nested academic data. For a university results portal, a hybrid approach offers the best balance between reliability, consistency, and flexibility.
