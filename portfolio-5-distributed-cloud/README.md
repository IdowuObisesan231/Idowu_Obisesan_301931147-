# Portfolio 5: Distributed and Cloud Database Exercise

## Purpose

This portfolio examines how the XYZ University Student Results Portal could be deployed in a distributed or cloud database environment. The system stores student profiles, departments, courses, registrations, grades, and lecturer assignments. As the university grows across campuses and student numbers increase, the database must continue to provide reliable access, protect academic records, and support reporting workloads.

This exercise focuses on:

- distributed database architecture and deployment choices
- cloud-managed relational databases
- replication, partitioning, availability, and recovery
- performance and consistency trade-offs
- the suitability of cloud databases for the university case study

## Case study requirements

The student portal should support:

- reliable course registration during peak enrolment periods
- accurate and auditable grade updates
- access for students, lecturers, and administrators across campuses
- reporting on registrations and academic performance
- backup and recovery in case of infrastructure failure

Grades and registration records are authoritative academic data, so correctness and transaction integrity take priority over accepting conflicting writes during a network failure.

## Proposed cloud architecture

A practical starting design is a managed PostgreSQL database with a primary instance, a standby for failover, and optional read replicas for reporting.

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

### Request flow

1. Users access the portal through the application.
2. Registration and grade changes are validated by the application and written to the primary database.
3. Read-heavy dashboards and reports may use a read replica when slightly delayed data is acceptable.
4. A standby instance can be promoted if the primary becomes unavailable, according to the cloud provider's failover configuration.
5. Automated backups and snapshots support restoration after accidental changes or infrastructure failure.

The primary remains the source of truth. The application should send reads that require the latest committed academic record to the primary rather than a potentially delayed replica.

## Replication and consistency

Replication copies database changes from one instance to another. It can improve availability and help distribute read workloads, but replicas may lag behind the primary.

For this portal:

- writes to grades and registrations should go to the primary
- reports may use replicas if the report can tolerate a short replication delay
- users should be told when report data is current as of a particular time if replica lag is possible
- grade changes should be audited, including who made the change and when

Synchronous replication can reduce the chance of losing recently committed changes during failover, but may increase write latency. Asynchronous replication can provide faster writes, but a recently committed change might not yet have reached a replica. The selected cloud service configuration should be tested against the university's recovery requirements.

## Partitioning and scaling

Partitioning divides a large table into smaller logical parts, often based on a date or other commonly filtered value. For example, registration records could be partitioned by academic year when the table becomes large and reports frequently filter by year.

Partitioning should be introduced only after measuring data volume and query performance. The existing unique rule for a registration—one student, course, semester, and academic year—must still be enforced correctly with the chosen partitioning strategy. Sharding across independent databases adds more complexity and should be considered only when a single managed database and read replicas no longer meet measured requirements.

Potential scaling steps, from simplest to more complex:

1. Add appropriate indexes and optimise slow queries.
2. Scale the managed database instance vertically when resource monitoring justifies it.
3. Add read replicas for read-heavy reports.
4. Partition large historical tables when query patterns and data volume warrant it.
5. Consider sharding only when the earlier approaches cannot satisfy requirements.

## Example PostgreSQL table

The relational schema can remain the authoritative transactional model in the cloud. This example follows the registration structure used in the earlier portfolios:

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

The table is illustrative; it should be created together with the related student and course tables and foreign keys from the relational schema in Portfolio 1.

## Cloud-managed database considerations

### Benefits

- managed backups and point-in-time recovery options
- high-availability and failover features, depending on service configuration
- capacity can be adjusted as measured workloads grow
- monitoring tools can report on database health and performance
- less infrastructure maintenance than operating database servers directly

### Costs and limitations

- ongoing charges depend on instance size, storage, backups, and data transfer
- application performance depends on network connectivity and database location
- replicas can return slightly stale data
- provider-specific features may complicate migration to another platform
- security and access policies still require careful configuration by the university

## Reliability, recovery, and security

A deployment plan should define and test:

- backup frequency and retention
- recovery point objective (RPO): how much recent data the university can tolerate losing
- recovery time objective (RTO): how long the portal can be unavailable
- failover behaviour and how applications reconnect
- restore procedures, including periodic recovery tests
- encryption in transit and at rest
- least-privilege accounts for applications, staff, and administrators
- audit logging for sensitive access and grade changes

Backups are not a substitute for testing restoration. The university should regularly verify that a backup can be restored and that the recovered database passes integrity checks.

## Cloud-managed versus self-hosted database

| Area | Cloud-managed database | Self-hosted database |
| --- | --- | --- |
| Infrastructure maintenance | Provider manages much of the infrastructure | University manages servers, storage, and maintenance |
| Scaling | Often available through service configuration | Requires planning and provisioning by the university |
| Backups and failover | Commonly supported, but must be configured and tested | Must be designed and operated by the university |
| Control | Some settings and infrastructure choices are provider-managed | Greater control over the environment |
| Cost | Usage-based recurring charges | Hardware, staffing, power, and maintenance costs |
| Portability | May use provider-specific features | Can be portable, depending on configuration |

## Recommendation

For the current XYZ University case study, begin with a managed PostgreSQL database configured for automated backups and high availability. Keep registration and grade transactions on the primary database. Add read replicas only when measured reporting workloads justify them, and route only delay-tolerant reports to those replicas. Consider partitioning or sharding later based on actual data growth and performance measurements rather than assuming they are necessary from the start.

## Evidence to include in the final portfolio

- a cloud architecture diagram or the architecture description above
- the chosen availability and backup configuration
- the replication and consistency trade-offs
- measured query or workload evidence if a database was deployed
- the university's proposed RPO and RTO, with a brief justification
- a comparison of managed cloud hosting and self-hosting
- a conclusion written in your own words

## Portfolio 5 submission checklist

- [ ] Cloud or distributed architecture described
- [ ] Primary, standby, and read-replica roles explained
- [ ] Replication lag and consistency trade-offs discussed
- [ ] Backup, recovery, and security requirements included
- [ ] Scaling choices justified by workload measurements
- [ ] Final recommendation written in your own words

## Conclusion

A managed cloud relational database is a suitable starting point for the XYZ University Student Results Portal because it can support transactional integrity while reducing infrastructure-management work. High availability, backups, and replicas can improve resilience and reporting capacity when configured and tested appropriately. Grade and registration records should remain authoritative and carefully audited, while more complex distribution techniques should be introduced only when measured needs justify their cost and operational complexity.

---

This file is part of the MIT 8103 Advanced Database Systems portfolio for the XYZ University Student Results Portal case study.
