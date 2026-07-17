# challenge_altaa.ai_monorepo

![TypeScript](https://img.shields.io/badge/TypeScript-5-3178C6?logo=typescript&logoColor=white)
![NestJS](https://img.shields.io/badge/NestJS-11-E0234E?logo=nestjs&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-15-000000?logo=next.js&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![CI](https://img.shields.io/github/actions/workflow/status/Thiago5g/challenge_altaa.ai_monorepo/monorepo-ci.yml?label=CI&logo=githubactions&logoColor=white)

**Enterprise management platform — Fullstack monorepo with NestJS, Next.js, and production-grade CI/CD.**

## Architecture

```
┌─────────────┐       ┌──────────────────┐       ┌──────────────────┐       ┌────────────┐
│   Client    │──────▶│  Next.js 15 App  │──────▶│  NestJS 11 API   │──────▶│ PostgreSQL │
│  (Browser)  │       │  (App Router)    │       │  (REST + JWT)    │       │            │
└─────────────┘       └──────────────────┘       └──────────────────┘       └────────────┘
                                                          │
                              ┌────────────────────────────┘
                              ▼
                 ┌───────────────────────────┐
                 │   GitHub Actions CI/CD    │
                 │  6 workflows · Codecov ·  │
                 │  Trivy · Dependabot       │
                 └───────────────────────────┘
```

## Features

### Backend
- NestJS 11 with Prisma 6 ORM and PostgreSQL
- JWT authentication with role-based access control (OWNER / ADMIN / MEMBER)
- Invitation system with 7-day token expiry
- **101 unit tests** with comprehensive service/controller coverage
- Swagger/OpenAPI documentation

### Frontend
- Next.js 15 App Router with React 19 and TypeScript 5
- Tailwind CSS + shadcn/ui component library
- Zod schema validation, Sonner toast notifications
- Jest + React Testing Library test suite

### DevOps
- Docker Compose orchestration (one-command startup)
- 6 GitHub Actions workflows: monorepo CI, backend CI, frontend CI, security scanning, PR checks, deploy
- Smart change detection — only affected services run in CI
- Codecov integration, Trivy container scanning, Dependabot, auto-labeling

## Quick Start

```bash
git clone --recurse-submodules https://github.com/Thiago5g/challenge_altaa.ai_monorepo.git
cd challenge_altaa.ai_monorepo

# Start all services
docker-compose up -d

# Or use the Makefile
make up
```

The app will be available at `http://localhost:3000` (frontend) and `http://localhost:3001` (API + Swagger).

## Tech Stack

| Layer      | Technology                                      |
|------------|-------------------------------------------------|
| Frontend   | Next.js 15, React 19, TypeScript, Tailwind, shadcn/ui |
| Backend    | NestJS 11, Prisma 6, PostgreSQL, JWT, Swagger   |
| Testing    | Jest, React Testing Library, 101+ unit tests    |
| DevOps     | Docker Compose, GitHub Actions, Codecov, Trivy  |
| Monorepo   | Git submodules, Makefile, cross-platform scripts |

## Running Tests

```bash
# Backend (101 unit tests)
cd backend && npm run test

# Frontend
cd frontend && npm run test

# Or via Makefile
make test
```

## Engineering Highlights

- **CI/CD maturity** — 6 purpose-built workflows with smart change detection, security scanning, and coverage reporting. No wasted compute on unchanged services.
- **Test coverage** — 101 backend unit tests covering auth flows, RBAC enforcement, invitation lifecycle, and error handling.
- **Role-based auth design** — Three-tier permission model (OWNER → ADMIN → MEMBER) with guard-level enforcement and invitation-based onboarding.
- **Monorepo management** — Git submodules keep repositories independently deployable while the root orchestrates CI, Docker, and developer tooling through a single Makefile.

## Project Structure

```
.
├── backend/              # NestJS API (git submodule)
├── frontend/             # Next.js app (git submodule)
├── .github/workflows/    # 6 CI/CD pipelines
├── docker-compose.yml    # Full-stack orchestration
├── Makefile              # Developer commands
├── CHANGELOG.md          # Release history
├── CI-CD.md              # CI/CD documentation
└── DOCKER.md             # Container setup guide
```

## Documentation

- [CI/CD Pipeline](./CI-CD.md) — Workflow architecture and trigger rules
- [Docker Setup](./DOCKER.md) — Container configuration and environment variables
- [Changelog](./CHANGELOG.md) — Version history across 15 commits

## License

MIT
