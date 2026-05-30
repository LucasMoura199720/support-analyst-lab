# Support Analyst Lab 🛠️

Practical technical laboratory built to demonstrate core competencies for a **Support Analyst (Tier 2)** role.  
Covers SQL database design, HelpDesk case analysis, cloud infrastructure monitoring, and technical troubleshooting.

---

## 📁 Repository Structure

```
support-analyst-lab/
│
├── sql/
│   ├── lab_dia1_sql_completo.sql     # Full schema + 10 annotated support queries
│   └── screenshots/                  # Query results (DB Browser for SQLite)
│
├── troubleshooting/
│   ├── case_report_ssh.md            # Incident report — SSH misconfiguration
│   ├── case_report_dns.md            # Incident report — DNS resolution failure
│   └── case_report_permissions.md   # Incident report — File permission error
│
├── azure/
│   ├── architecture_diagram.png      # Hybrid infrastructure layout
│   ├── incident_report_azure.md      # Azure Monitor alert simulation
│   └── screenshots/                  # Azure portal evidence
│
└── README.md
```

---

## Lab 1 — SQL HelpDesk Database

**Goal:** Design and query a relational database that simulates a real CRM/HelpDesk system (modelled after Creatio's data structure).

### Schema overview

| Table | Description |
|---|---|
| `customers` | End users and companies using the platform |
| `agents` | Support team members (Tier 1, Tier 2, Cloud, Database) |
| `products` | Product modules (CRM, Workflow, Integration, Cloud, Mobile) |
| `tickets` | Support cases with status, priority, escalation flag |
| `activities` | Case activity log — notes, emails, calls, resolutions |

### 10 queries built

| # | Query | Business purpose |
|---|---|---|
| 1 | Work queue by priority | First view an agent opens at shift start |
| 2 | Ticket load per agent | Workload balancing across the team |
| 3 | Top 5 oldest open tickets | SLA breach detection |
| 4 | Tickets per product module | Identifies most problematic modules |
| 5 | All escalated tickets | Manager visibility on critical cases |
| 6 | Mean time to resolve by priority | Support performance metric (MTTR) |
| 7 | Unassigned open tickets | Orphaned case detection |
| 8 | Agent activity breakdown | Work pattern analysis per agent |
| 9 | Customers with most escalations | At-risk customer health score |
| 10 | Silent tickets (no recent activity) | Most critical — detects stalled cases |

### Concepts demonstrated

- `JOIN` across multiple related tables
- `LEFT JOIN` to include records with no matches
- `GROUP BY` with `SUM(CASE WHEN ...)` for conditional aggregation
- `julianday()` for date difference calculations (days open, MTTR)
- `HAVING` for post-aggregation filtering
- `COALESCE` for null-safe expressions
- `ORDER BY CASE` for custom priority sorting
- `IS NULL` for unassigned/unresolved detection

### How to run

1. Install [DB Browser for SQLite](https://sqlitebrowser.org) (free, Windows/Mac/Linux)
2. Open DB Browser → **New Database** → save as `support.db`
3. **File → Import → Database from SQL file** → select `lab_dia1_sql_completo.sql`
4. Go to the **Execute SQL** tab and run each query individually

---

## Lab 2 — Linux Troubleshooting (Tier 2 Case Simulation)

**Goal:** Simulate real Tier 2 support scenarios on a Linux VM — introduce deliberate failures, diagnose using standard tools, document findings in professional case report format.

### Cases simulated

| Case | Failure introduced | Tools used |
|---|---|---|
| SSH misconfiguration | Wrong port in `sshd_config` | `systemctl status`, `journalctl`, `netstat` |
| DNS resolution failure | Incorrect nameserver in `resolv.conf` | `nslookup`, `dig`, `ping` |
| File permission error | Incorrect `chmod` on service file | `ls -la`, `chmod`, `chown` |

### Case report format used

Each incident is documented as a Support Analyst would write it — for both the customer and the internal development team:

```
Title:       [Short description of the issue]
Environment: [OS, service, version]
Reported by: [Customer / internal]
Priority:    [Critical / High / Medium / Low]

CONTEXT
  What was happening and what triggered the report.

DIAGNOSIS
  Step-by-step investigation — commands run, output observed.

ROOT CAUSE
  Exact technical cause identified.

RESOLUTION
  Actions taken to fix the issue.

VERIFICATION
  How resolution was confirmed.

PREVENTION
  Recommendation to avoid recurrence.
```

---

## Lab 3 — Azure Infrastructure Monitoring

**Goal:** Deploy a cloud environment in Microsoft Azure, simulate a service incident, investigate using Azure Monitor, and document the full resolution cycle.

### Architecture deployed

- Windows Server VM (Azure IaaS)
- Web application service (IIS)
- Azure Monitor with CPU and availability alerts
- Log Analytics workspace for log investigation

### Incident simulated

Service intentionally stopped → alert triggered → logs investigated in Azure Monitor → root cause identified → service restored and confirmed.

### Concepts demonstrated

- Azure VM provisioning and configuration
- Azure Monitor alert rules and action groups
- Log Analytics queries for incident investigation
- RBAC and resource group permissions
- Incident documentation from detection to resolution

---

## Technical Stack

![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat&logo=sqlite&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?style=flat&logo=microsoftazure&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
![Windows Server](https://img.shields.io/badge/Windows_Server-0078D6?style=flat&logo=windows&logoColor=white)

**Skills demonstrated:** SQL · Relational databases · Linux administration · Cloud monitoring · Incident management · Technical documentation · Root cause analysis

---

## About

Built by **Lucas Araújo da Costa Moura** as part of active preparation for a Support Analyst (Tier 2) role.  
Background in Systems Administration, Networking and Cloud Computing (Azure + AWS).

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/lucas-moura-1425461a2)

---

*Laboratory in active development — Labs 2 and 3 being added daily.*
