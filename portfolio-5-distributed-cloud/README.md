# Portfolio 5: Distributed and Cloud Database Exercise

## Purpose

This portfolio examines how the XYZ University Student Results Portal could be designed and deployed in a distributed or cloud database environment. The university system contains student records, department information, course registrations, lecturer assignments, and grade history. As the institution grows, the database must support larger workloads, greater concurrency, and better fault tolerance without compromising academic integrity.

The main tasks in this portfolio are:

- explain why a distributed or cloud-based design may be needed
- describe a suitable architecture for the student records system
- discuss replication, partitioning, and availability
- explain the trade-offs between consistency and performance
- justify the choice of a cloud-managed database for the case study

## Why distributed and cloud databases matter

A modern university system may need to support:

- large numbers of students and lecturers
- increased registration activity during enrolment periods
- frequent reporting on academic performance
- access from several campuses or remote locations
- higher availability and resilience for critical academic records

A single local database may be adequate for a small environment, but a distributed or cloud-based design becomes important when scale, availability, and disaster recovery become significant requirements.

## Example architecture

A practical starting point is a managed PostgreSQL database in a cloud environment. The database can be configured with a primary instance, failover standby, and read replicas for reporting.

```text
Students / Lecturers / Administrators
                 |
          Web application
                 |
       Application load balancer
                 |
       Managed PostgreSQL primary
          /                 \
   Standby replica       Read replica(s)
   (failover)            (reports / dashboards)
          |
   Automated backups and snapshots
```

### How this supports the university system

- the primary database handles all writes to grades and registrations
- read replicas support reporting and academic dashboards
- failover ensures that the system can continue operating if the primary instance fails
- backups and snapshots support restoration in the event of accidental changes or infrastructure failures

## Replication and consistency

Replication is the process of copying data from one database instance to another. This improves availability and allows read workload distribution, but it also introduces potential delay between the primary and the replicas.

For the student portal:

- registration and grade updates should be written to the primary database
- report queries may use replicas if slight delay is acceptable
- final academic records must remain consistent and auditable
- grade changes should be logged with timestamps and user actions

A distributed system often faces a trade-off between consistency and availability. For academic records, a strong consistency model is usually preferred for grade changes and student registration. Read-heavy reports can tolerate some delay if the application clearly handles replica lag.

## Partitioning and scaling

As the database grows, partitioning or sharding may become useful. Partitioning divides large tables into smaller logical units, often by academic year, department, or a relevant date range.

For example, the `registration` table may later be partitioned by `academic_year` when reporting and record volume increase. Partitioning should only be introduced when there is evidence that query patterns and table size justify it.

A sensible scaling sequence is:

1. optimise indexes and review slow queries
2. increase database capacity when needed
3. add read replicas for reporting loads
4. introduce partitioning for historical or large tables
5. consider sharding only when the earlier options are no longer sufficient

## Example table in a distributed environment

The relational model remains the core transactional structure. The registration table continues to play a central role in the student system.

```sql
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
    CHECK (grade IN ('A', 'B', 'C', 'D', 'E', 'F', 'W', 'WA', 'I'))
);
```

This table can be retained in a cloud-managed relational database while the deployment architecture is adapted for scale and resilience.

## Cloud-managed database considerations

### Advantages

- managed backups and point-in-time recovery
- automatic failover support in many cloud providers
- easier scaling to meet student demand
- reduced systems administration effort for the university
- better disaster recovery capabilities than a manually managed database server

### Limitations

- cloud costs can increase as the system grows
- provider-specific features may affect portability
- network latency may influence application performance
- replica lag must be managed carefully for academic reporting
- security and access control still require careful configuration

## Reliability and security

The university system should include:

- regular automated backups
- periodic restore testing
- database monitoring and alerting
- secure connection encryption
- role-based access control for students, lecturers, administrative staff, and developers
- audit logs for changes to final grades and core academic records

These controls are essential because the university portal stores information that affects academic progression and institutional records.

## Cloud-managed vs self-hosted deployment

| Area | Cloud-managed database | Self-hosted database |
| --- | --- | --- |
| Maintenance | Provider manages infrastructure and updates | University manages servers, patches, and maintenance |
| Scaling | Usually easier through service configuration | Requires university planning and provisioning |
| Backups and failover | Often built into the service | Must be designed and operated manually |
| Cost | Usage-based recurring cost | Hardware, staffing, and operations cost |
| Control | Some environment choices are provider-managed | Greater control over infrastructure |
| Portability | May use provider-specific features | More portable if configured carefully |

## Recommended design for this portfolio

For the XYZ University Student Results Portal, the recommended starting point is a managed PostgreSQL database deployed in a cloud environment. The primary instance should handle all change operations, while read replicas can support reporting dashboards. A standby instance should be configured for failover, and scheduled backups should be tested regularly to confirm recovery readiness.

This design supports the case study without introducing unnecessary complexity too early.

## Suggested files for submission

- `cloud_architecture.md` — diagram or architecture summary
- `distributed_design_notes.md` — notes on replication and partitioning
- `cloud_db_summary.md` — explanation of the chosen cloud database strategy

## Evidence to include in the final portfolio

The final report should include:

- a description of the distributed or cloud architecture
- a discussion of replication and partitioning choices
- a short explanation of fault tolerance and backup strategy
- a comparison of cloud-managed and self-hosted deployment models
- a conclusion describing whether the design is suitable for the student portal

## Portfolio 5 submission checklist

- [ ] Distributed database scenario identified
- [ ] Cloud architecture described clearly
- [ ] Replication and partitioning discussed
- [ ] Reliability and security explained
- [ ] Final recommendation written in the student’s own words

## Conclusion

A distributed or cloud-based database design is highly relevant to the XYZ University Student Results Portal as the system grows. While the core academic data still benefits from a relational model, a managed cloud environment can improve resilience, scalability, and operational efficiency. The most suitable approach for this case study is a managed relational database with strong backup and failover support, with more advanced distribution methods introduced only when workload and performance evidence justify them.

---

This file is part of the MIT 8103 Advanced Database Systems portfolio for the XYZ University Student Results Portal case study.
