<div align="center">

# SmartDesk
### Semantic IT & Facilities Helpdesk

**A centralized, context-aware helpdesk for reporting, routing, tracking, and resolving workplace IT and facilities issues.**

[![Next.js](https://img.shields.io/badge/Next.js-14-black?logo=next.js)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)](https://react.dev/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14%2B-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![pgvector](https://img.shields.io/badge/pgvector-vector%20search-336791)](https://github.com/pgvector/pgvector)
[![License](https://img.shields.io/badge/License-Not%20specified-lightgrey)](#license)

[Overview](#-overview) · [Problem](#-problem-statement) · [Features](#-key-capabilities) · [Architecture](#-system-architecture) · [Setup](#-getting-started) · [Database](#-database-setup) · [Run](#-run-the-application) · [Troubleshooting](#-troubleshooting)

</div>

---

## 📌 Overview

SmartDesk is a semantic IT and facilities helpdesk concept built to make internal issue management more organized and knowledge-driven. Employees can report workplace problems, while support teams can review, prioritize, assign, and resolve tickets through a centralized workflow.

Unlike a basic keyword-only ticket list, the project is designed to use **semantic similarity** to find previously resolved issues that are phrased differently but describe a similar problem. This can help surface relevant fixes and reduce repeated troubleshooting.

The repository identifies the project as a DBMS experiential-learning project and lists Next.js, PostgreSQL, and pgvector as its core technologies.

> **Repository status note:** This README documents the intended system and the setup indicated by the repository. The public repository currently exposes a small initial codebase. Verify that the referenced SQL files and embedding script are present in your local checkout before following those steps. Features described as capabilities below should not be interpreted as proof that every screen or workflow is already complete.

## 🎯 Problem Statement

Organizations often receive IT and facilities complaints through emails, phone calls, chat messages, or informal conversations. When these requests are handled separately, support teams can struggle to maintain a reliable record of issues and their resolutions.

### Existing pain points

- **Scattered requests:** Employees use different channels to report problems.
- **Repeated troubleshooting:** Similar incidents are investigated from scratch because previous fixes are difficult to discover.
- **Manual assignment:** Tickets may be sent to the wrong team or technician.
- **Uneven workload:** Managers may not have a clear view of technician assignments.
- **SLA visibility:** Deadlines and overdue requests can be difficult to monitor consistently.
- **Knowledge loss:** Useful resolutions may remain buried in old tickets instead of becoming reusable support knowledge.

### Proposed solution

SmartDesk aims to provide one place to:

1. Submit and track IT or facilities tickets.
2. Search historical tickets using semantic similarity.
3. Surface relevant previously resolved incidents and verified fixes.
4. Route or triage new tickets for the appropriate support team.
5. Assign work with technician workload in mind.
6. Track status, ownership, history, and service deadlines.
7. Give administrators an operational view of support activity.

### Project objectives

- Centralize issue reporting and resolution records.
- Make historical support knowledge easier to reuse.
- Demonstrate vector similarity search using PostgreSQL and pgvector.
- Apply database concepts such as relational modelling, constraints, indexes, triggers, procedures, and views where implemented.
- Keep the workflow understandable for employees, technicians, and administrators.

## ✨ Key Capabilities

The following table describes the intended product capabilities. Confirm each one against the current application before presenting it as completed.

| Area | Capability | Purpose |
|---|---|---|
| Employee | Ticket submission | Record an issue with its description and relevant details |
| Employee | Ticket history and status | Follow progress and see ownership |
| Knowledge search | Similar-ticket suggestions | Find older incidents with similar meaning |
| Technician | Assigned-ticket queue | Review and work on allocated requests |
| Technician | Resolution notes | Record the steps taken to fix an issue |
| Admin | Ticket triage | Review, prioritize, and route incoming work |
| Admin | Assignment management | Allocate or reassign tickets |
| Admin | SLA and workload monitoring | Identify overdue work and uneven workloads |
| AI assistance | Resolution explanation | Present a clearer explanation of a suggested fix, where configured |

### Typical user journey

```mermaid
flowchart TD
    A[Employee reports an issue] --> B[Ticket is stored]
    B --> C[Generate or retrieve text embedding]
    C --> D[Search similar historical tickets]
    D --> E{Useful verified match found?}
    E -- Yes --> F[Show related ticket and suggested fix]
    E -- No --> G[Continue with normal triage]
    F --> G
    G --> H[Route and assign ticket]
    H --> I[Technician investigates]
    I --> J[Resolution is recorded]
    J --> K[Ticket is closed or verified]
    K --> L[Resolution becomes searchable knowledge]
```

*This is the intended workflow. Exact automation and transition rules depend on the implementation in the repository.*

## 🧠 Semantic Search: How It Works

Traditional keyword search looks for matching words. Semantic search attempts to identify similarity in meaning.

For example:

- Previous ticket: “Laptop cannot connect to the office wireless network.”
- New ticket: “My computer is not joining the company Wi-Fi.”

The wording is different, but the underlying issue may be similar.

### Embedding and retrieval pipeline

1. **Input text:** Take the issue title and/or description.
2. **Embedding:** Convert the text into a numeric vector using the configured sentence-embedding model. The project plan references a MiniLM model with 384-dimensional embeddings.
3. **Storage:** Store the vector alongside the relevant ticket in PostgreSQL using pgvector.
4. **Similarity search:** Compare the new vector with stored ticket vectors.
5. **Results:** Return the most relevant historical tickets for review.
6. **Resolution assistance:** Where configured, an AI explanation service can explain a retrieved fix in simpler language.

```mermaid
flowchart LR
    A[New ticket text] --> B[Embedding model]
    B --> C[384-dimensional vector]
    C --> D[(PostgreSQL + pgvector)]
    D --> E[Similarity ranking]
    E --> F[Related historical tickets]
    F --> G[Technician reviews suggested fix]
```

**Important:** Similarity is a recommendation signal, not proof that two incidents have the same cause. A technician should validate a suggested resolution before applying it.

## 🏗️ System Architecture

SmartDesk is organized around a Next.js application and a PostgreSQL database with vector-search support.

```mermaid
flowchart TB
    U[Employee / Technician / Admin] --> UI[Next.js UI]
    UI --> API[Next.js API routes / server logic]
    API --> AUTH[Authentication and authorization]
    API --> DB[(PostgreSQL)]
    API --> EMB[Embedding service]
    EMB --> VEC[pgvector similarity search]
    VEC --> DB
    API --> AI[Optional Gemini explanation service]
    DB --> API
    API --> UI
```

### Technology stack

| Layer | Technology | Role |
|---|---|---|
| Web application | Next.js 14 | Application framework and server-side routes |
| UI | React 18 | Component-based interface |
| Database | PostgreSQL 14+ | Persistent relational data |
| Vector search | pgvector | Store and compare embedding vectors |
| Database driver | `pg` | Connect the Node.js application to PostgreSQL |
| Embeddings | `@xenova/transformers` | Run text embedding models in the JavaScript environment |
| Authentication configuration | JWT secret | Secret used by authentication-related code, if implemented |
| AI explanations | Gemini (planned/configuration-dependent) | Explain retrieved resolutions, not determine routing by itself |

## 🧰 Getting Started

### Prerequisites

Install the following before starting:

| Requirement | Recommended version | Why it is needed |
|---|---:|---|
| Node.js | 20 LTS or newer | Run the Next.js application and scripts |
| npm | Bundled with Node.js | Install project dependencies |
| PostgreSQL | 14 or newer | Store application data |
| pgvector | Version compatible with PostgreSQL | Enable vector storage and similarity search |
| Git | Recent version | Clone the repository |
| Code editor | VS Code or equivalent | Edit configuration and source files |

Check your installations:

```bash
node --version
npm --version
git --version
psql --version
```

Check that pgvector is available in PostgreSQL by connecting to your database and running:

```sql
SELECT * FROM pg_available_extensions WHERE name = 'vector';
```

If no row is returned, install pgvector for your PostgreSQL installation before continuing.

### 1. Clone the repository

```bash
git clone https://github.com/PES1UG24AM378/SMARTDESK.git
cd SMARTDESK
```

### 2. Install dependencies

```bash
npm install
```

### 3. Configure environment variables

Create a local environment file by copying the example.

**Windows PowerShell:**

```powershell
Copy-Item .env.example .env.local
```

**macOS / Linux:**

```bash
cp .env.example .env.local
```

Open `.env.local` and replace the sample values:

```env
DATABASE_URL=postgresql://YOUR_DB_USER:YOUR_DB_PASSWORD@localhost:5432/smartdesk
JWT_SECRET=replace-with-a-long-random-secret
```

Update the database username, password, host, and database name to match your local PostgreSQL setup.

- `DATABASE_URL`: PostgreSQL connection string.
- `JWT_SECRET`: Secret for signing/verifying tokens if the authentication implementation uses JWT.

**Security rules**

- Never commit `.env.local`.
- Never paste real credentials or API keys into public issues or README files.
- Keep `.env.example` limited to placeholder values.
- If an optional Gemini integration is enabled in your code, add its required key to `.env.local` using the exact variable name expected by that implementation. Do not assume a variable name without checking the source.

## 🗄️ Database Setup

Create a database for the project. For example, from `psql`:

```sql
CREATE DATABASE smartdesk;
```

Connect to it:

```bash
psql -U YOUR_DB_USER -d smartdesk
```

Enable pgvector:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

### Initialize the project schema

The repository's initial setup instructions specify this order:

1. `db/schema.sql` — create database objects.
2. `db/seed.sql` — insert sample data.
3. `node scripts/embed.js` — generate embeddings for the seed records.

Run the SQL scripts from the project root:

```bash
psql -U YOUR_DB_USER -d smartdesk -f db/schema.sql
psql -U YOUR_DB_USER -d smartdesk -f db/seed.sql
```

Then generate embeddings:

```bash
npm run embed
```

The `embed` npm script maps to `node scripts/embed.js`.

> **Check before running:** The repository's root listing currently shows `db/` and `lib/`, but the public listing does not expose the contents of `db/` or a `scripts/` directory. Confirm that `db/schema.sql`, `db/seed.sql`, and `scripts/embed.js` exist in your checkout. If any are missing, the setup is incomplete and those files must be added or the instructions updated to match the actual implementation.

### Verify the database

After initialization, connect to PostgreSQL:

```bash
psql -U YOUR_DB_USER -d smartdesk
```

List tables:

```sql
\dt
```

Check that the vector extension is enabled:

```sql
SELECT extname FROM pg_extension WHERE extname = 'vector';
```

The exact tables and verification queries depend on the schema files supplied by the project.

## ▶️ Run the Application

Start the development server:

```bash
npm run dev
```

Open:

**http://localhost:3000**

For a production build:

```bash
npm run build
npm run start
```

Stop the development server with `Ctrl + C`.

### Available npm scripts

| Command | Purpose |
|---|---|
| `npm install` | Install dependencies |
| `npm run dev` | Start the local development server |
| `npm run build` | Create a production build |
| `npm run start` | Run the production build |
| `npm run embed` | Run the embedding script (`node scripts/embed.js`) |

## 🗂️ Repository Structure

### Structure visible in the public repository

The public repository currently exposes the following top-level files and directories:

```text
SMARTDESK/
├── db/                 # Database scripts (inspect directory for exact files)
├── lib/                # Shared application logic (inspect directory for exact files)
├── .env.example        # Environment variable template
├── .gitignore          # Git exclusions
├── package.json        # Dependencies and npm scripts
├── package-lock.json   # Locked dependency versions
└── README.md           # Project documentation
```

### Intended logical organization

The following is a recommended way to organize the code as the project grows. It is a logical guide, **not a claim that every path already exists in the current repository**.

```text
SMARTDESK/
├── app/
│   ├── (auth)/                 # Login and authentication pages
│   ├── employee/               # Employee ticket experience
│   ├── technician/             # Technician workspace
│   ├── admin/                  # Admin dashboard
│   └── api/                    # Next.js route handlers
├── components/
│   ├── layout/                 # Shared navigation and layout
│   ├── tickets/                # Ticket-related UI
│   └── dashboard/              # Dashboard widgets
├── lib/
│   ├── db.js                   # Database connection utilities
│   ├── embeddings.js           # Text embedding generation
│   ├── similarity.js           # Similar-ticket retrieval
│   ├── decide.js               # Routing/assignment decision logic
│   └── explain.js              # Resolution explanation integration
├── db/
│   ├── schema.sql              # Tables, constraints, indexes
│   ├── seed.sql                # Development/demo records
│   ├── triggers.sql            # Database triggers, if separated
│   ├── procedures.sql          # Stored procedures, if separated
│   └── views.sql               # Reporting views, if separated
├── scripts/
│   └── embed.js                # Generate embeddings for existing records
├── tests/                      # Automated tests
├── docs/                       # Architecture, ERD, API and setup docs
├── .env.example                # Safe configuration template
├── .gitignore
├── package.json
└── README.md
```

### Where to look when debugging

- Application startup and dependencies: `package.json`
- Database connection and shared logic: `lib/`
- Database schema and sample records: `db/`
- Environment configuration: `.env.local` (local only) and `.env.example` (committed template)
- Embedding generation: `scripts/embed.js`, if present

## 🔌 API and Application Workflows

The repository is a Next.js project, so server endpoints—when implemented—are typically defined as route handlers under `app/api/`.

Document each endpoint in this format when the routes are finalized:

| Method | Endpoint | Purpose | Status |
|---|---|---|---|
| `POST` | `/api/tickets` | Create a ticket | Verify in source |
| `GET` | `/api/tickets` | List or filter tickets | Verify in source |
| `GET` | `/api/tickets/:id` | Retrieve ticket details | Verify in source |
| `PATCH` | `/api/tickets/:id` | Update ticket fields/status | Verify in source |
| `GET` | `/api/tickets/:id/similar` | Retrieve semantically similar tickets | Verify in source |

> These are endpoint design examples, not verified live routes. Replace this table with the actual route handlers and request/response examples before claiming API support.

## 🧪 Testing and Quality Checks

Before submitting changes, run the checks supported by the project:

```bash
npm run build
```

If automated tests are added, document and run the test command here. The current `package.json` does not declare a test script, so do not assume `npm test` is available.

Suggested quality checks for the project:

- Validate required fields before creating tickets.
- Use parameterized SQL queries.
- Enforce authorization on server-side routes.
- Validate ticket status transitions.
- Test similarity search with paraphrased descriptions.
- Verify that only appropriate historical resolutions are suggested.
- Test SLA calculations around deadline boundaries.
- Keep secrets out of source control.

## 🔐 Security and Configuration Notes

- Keep database credentials and JWT secrets in local environment variables.
- Do not expose database connection strings to browser-side code.
- Perform role and permission checks on the server, not only in the UI.
- Use parameterized database queries to reduce SQL injection risk.
- Validate and normalize incoming ticket data.
- Treat retrieved historical fixes as suggestions that require review.
- Avoid logging passwords, tokens, or sensitive employee information.

## 🛠️ Troubleshooting

| Problem | Likely cause | What to check |
|---|---|---|
| `npm` is not recognized | Node.js/npm is not installed or PATH is not refreshed | Install Node.js, reopen the terminal, run `node --version` |
| `npm install` fails | Network, Node version, or dependency issue | Check Node version and the full npm error |
| Database connection refused | PostgreSQL is stopped or host/port is wrong | Start PostgreSQL and verify `DATABASE_URL` |
| Password authentication failed | Incorrect database credentials | Update `.env.local` and retry |
| `extension "vector" is not available` | pgvector is not installed for this PostgreSQL instance | Install a compatible pgvector package |
| `db/schema.sql` not found | SQL file is missing or path differs | Inspect the `db/` directory and correct the command |
| `scripts/embed.js` not found | Embedding script is missing or path differs | Inspect the repository and update the script or npm command |
| Port 3000 is in use | Another process is using the port | Stop that process or use the port suggested by Next.js |
| Build fails | Missing environment variable or source error | Read the first meaningful error in the terminal |

## 🚀 Future Improvements

Potential next steps, depending on project scope:

- Complete employee, technician, and admin role-based experiences.
- Add ticket filters, pagination, and audit history.
- Improve semantic ranking with category and status-aware filtering.
- Add feedback on whether suggested resolutions were useful.
- Add SLA escalation notifications.
- Add automated tests for database routines and API routes.
- Add CI checks for linting, tests, and production builds.
- Add deployment documentation and operational monitoring.

## 🤝 Contributing

1. Fork the repository.
2. Create a focused branch:

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make and test your changes.
4. Commit with a clear message:

   ```bash
   git add .
   git commit -m "feat: describe your change"
   ```

5. Push your branch and open a Pull Request describing the change and how it was tested.

## 📚 Learning Outcomes

This project can demonstrate practical application of:

- Relational database design and normalization.
- Primary keys, foreign keys, constraints, and indexes.
- SQL queries and transaction handling.
- Stored procedures, triggers, and views (where implemented).
- PostgreSQL extension usage.
- Vector embeddings and semantic similarity retrieval.
- Full-stack application development with Next.js and React.
- Secure configuration and collaborative development using Git.

## 📄 License

No license is currently specified in the repository. Unless a license is added, do not assume that the source code is open for reuse, redistribution, or modification by others.

---

<div align="center">

**SmartDesk — Turning recurring workplace issues into searchable support knowledge.**

Built as a DBMS Experiential Learning Project.

</div>
