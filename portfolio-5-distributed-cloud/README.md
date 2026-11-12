# Portfolio 5: Distributed and Cloud Database Exercise

## Purpose

This portfolio considers how the XYZ University Student Results Portal could be designed in a distributed or cloud-based environment. The focus is on scalability, reliability, backup, failover, and the practical use of managed database services.

## Case study context

The university database stores academic data across departments, lecturers, students, and registrations. As the number of students grows, more pressure is placed on database availability and reporting performance. The database must support both current academic operations and future growth in student numbers and course registrations.

## Recommended architecture

A strong starting point for the university is a managed relational database in the cloud, such as PostgreSQL on a cloud platform. The architecture can include:

- primary database instance for transactional operations
- read replicas for reporting and analytics
- automated backups for disaster recovery
- multi-zone or failover support for availability
- secure access control for students, lecturers, and administrators

## Cloud-managed database considerations

### Advantages

- automatic backups and point-in-time recovery
- easier failover and resilience
- reduced administrative burden
- improved scaling for reporting workloads
- better support for disaster recovery planning

### Limitations

- cloud costs can grow with scale
- provider-specific features may affect portability
- network latency can affect distributed access
- replication delay needs monitoring

## Reliability and security

The university system should include:

- regular automated backups
- periodic restore testing
- database monitoring and alerts
- encrypted access
- role-based user access control
- audit logs for grade updates and critical academic records

## Distributed database design idea

For a large institution, the system can be partitioned by function or by academic area, for example:

- Student and registration data
- Lecturer and course assignment data
- Department records and reporting tables

This helps distribute workloads while keeping the core academic model consistent.

## Conclusion

A distributed or cloud-based database design is highly relevant to the XYZ University Student Results Portal as student numbers and reporting demands increase. While the core academic model remains relational, a managed cloud environment improves resilience, availability, and maintainability. For this assignment, the most suitable approach is a cloud-managed relational database with backup, monitoring, failover, and optional read replicas for reporting.
