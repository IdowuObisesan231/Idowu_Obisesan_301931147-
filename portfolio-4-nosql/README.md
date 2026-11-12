# Portfolio 4: NoSQL and Advanced Data Models

## Purpose

This portfolio explores whether the XYZ University Student Results Portal can benefit from a NoSQL design for certain parts of the system. The university case study includes student records, grades, registrations, course schedules, and reporting workloads that can vary over time. A relational database is strong for transactional consistency, but some academic data may fit a document-oriented or distributed model better when scale, flexibility, and rapid reads are important.

The main tasks in this portfolio are:

- identify which parts of the student portal are better suited to NoSQL
- design a NoSQL data model for a realistic academic workload
- compare relational and NoSQL design choices
- explain consistency, schema flexibility, and query trade-offs
- document the suitability of the model for the case study

## Case study fit for NoSQL

The university system stores several different kinds of data:

- student profiles and contact details
- department and course metadata
- academic registrations and grades
- lecture and course assignment records
- reporting data for dashboards and academic analysis

A single relational schema works well for transactions and integrity checks, but some data sets are naturally semi-structured and evolve over time. For example, each student may have a profile with personal data, enrolled courses, grades, and academic history. This is a good fit for a document model where a single JSON document can represent the student's academic record.

## Suggested NoSQL model

### Option: Document-oriented model

A MongoDB-style collection named `students` can store one document per student. The document can contain a nested structure for academic history and registrations.

```json
{
  "student_id": 101,
  "student_number": "20240001",
  "first_name": "Ada",
  "last_name": "Nje",
  "email": "ada.nje@xyz.edu",
  "department": "Computer Science",
  "admission_year": 2024,
  "status": "active",
  "registrations": [
    {
      "course_code": "CS101",
      "course_title": "Introduction to Programming",
      "semester": "2026/2027 Sem 1",
      "academic_year": "2026/2027",
      "grade": "B",
      "credits": 3,
      "status": "completed"
    },
    {
      "course_code": "CS201",
      "course_title": "Data Structures",
      "semester": "2026/2027 Sem 2",
      "academic_year": "2026/2027",
      "grade": "A",
      "credits": 3,
      "status": "completed"
    }
  ],
  "created_at": "2026-01-15T09:30:00Z"
}
```

### Why this model is useful

- student-specific academic data is kept together in one place
- nested course registration data is easy to read and update
- flexible fields can support future requirements such as co-curricular activities or advisor notes
- queries for student history and course summaries are quick to retrieve

## Example NoSQL queries

### 1. Find a student and their academic record

```javascript
db.students.find({ student_number: "20240001" })
```

### 2. Find all students with a grade below B in a course

```javascript
db.students.find({
  "registrations.course_code": "CS101",
  "registrations.grade": { $in: ["C", "D", "E", "F"] }
})
```

### 3. Count the number of registered students per department

```javascript
db.students.aggregate([
  { $group: { _id: "$department", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

### 4. List the courses of a student in a semester

```javascript
db.students.find(
  { student_number: "20240001" },
  { "registrations": 1 }
)
```

## When NoSQL is suitable

NoSQL is particularly suitable when:

- data is highly nested or document-like
- academic data changes frequently and evolves over time
- there are many read-heavy student profile queries
- large-scale reporting and analytics are required
- the system needs flexible schema updates without major migration work

## When relational databases remain better

The relational model is still preferred when:

- strong transactional integrity is required
- data must obey strict foreign-key constraints
- complex multi-table joins are common
- academic records must be highly consistent across departments and modules
- the system requires standard SQL reporting and auditing

## Comparison: relational vs NoSQL

| Requirement | Relational database | NoSQL document database |
| --- | --- | --- |
| Student registration integrity | Strong with foreign keys and checks | Weaker unless application logic validates data |
| Schema flexibility | Fixed schema | Dynamic and flexible |
| Read performance on nested records | Can be good with indexes | Very good for document reads |
| Reporting and analytics | Excellent with SQL joins | Good but may require aggregation pipelines |
| Multi-table consistency | Strong | More complex |

## Data model recommendation

For the XYZ University portal, the best practical design is hybrid:

- use a relational database for transactional core data such as registrations, grades, departments, and lecturers
- keep a NoSQL document store for student profile summaries, academic history, and search-heavy academic dashboards
- use the relational system as the source of truth for final grades and records

This hybrid approach gives both reliability and flexibility.

## Suggested files for submission

- `nosql_model.json` — sample student document
- `nosql_queries.js` — example MongoDB queries
- `nosql_evaluation.md` — notes comparing relational and NoSQL suitability

## Evidence to include in the final portfolio

The final portfolio should include:

- a clear explanation of why NoSQL is relevant to the case study
- a document-based schema or sample JSON record
- example query results or expected outputs
- a discussion of strengths and limitations
- a conclusion on whether NoSQL is a good fit for the university system

## Portfolio 4 submission checklist

- [ ] NoSQL use case explained for the student portal
- [ ] Document model or JSON structure included
- [ ] Example queries shown
- [ ] Relational vs NoSQL differences discussed
- [ ] Final recommendation written in your own words

## Conclusion

NoSQL is not a replacement for the relational model in every case. However, for student profiles, nested academic records, and analytical access patterns, a document-based design can improve flexibility and read performance. For a university results portal, the strongest design is often a hybrid system where the transactional core stays relational and the flexible, read-heavy data is supplemented by NoSQL structures.

---

This file is part of the MIT 8103 Advanced Database Systems portfolio for the XYZ University Student Results Portal case study.
