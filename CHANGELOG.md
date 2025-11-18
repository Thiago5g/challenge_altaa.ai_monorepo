# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added - CI/CD (2025-11-17)

#### Workflows
- **Monorepo CI** (`.github/workflows/ci.yml`)
  - Detecção inteligente de mudanças usando `dorny/paths-filter`
  - Executa apenas jobs necessários baseado em arquivos modificados
  - Jobs separados: backend-ci, frontend-ci, docker-build
  - Job final de status para branch protection

- **Backend CI** (`.github/workflows/backend.yml`)
  - PostgreSQL service container para testes reais
  - Prisma migrations automáticas
  - Testes com coverage
  - Upload para Codecov
  - Triggers apenas em mudanças de backend

- **Frontend CI** (`.github/workflows/frontend.yml`)
  - Build do Next.js
  - Type checking TypeScript
  - Verificação de artefatos de build
  - Triggers apenas em mudanças de frontend

- **Security** (`.github/workflows/security.yml`)
  - npm audit para backend e frontend
  - Trivy scan para imagens Docker
  - Dependency review em PRs
  - Execução semanal (segundas, 9h UTC)
  - Upload de vulnerabilidades para GitHub Security

- **PR Checks** (`.github/workflows/pr-checks.yml`)
  - Estatísticas de PR (commits, arquivos, linhas)
  - Auto-labeling baseado em arquivos modificados
  - Validação de mensagens de commit (conventional commits)
  - Busca por TODOs e FIXMEs
  - Detecção de secrets com Gitleaks

- **Deploy** (`.github/workflows/deploy.yml`)
  - Build e push de imagens Docker para GHCR
  - Tagging automático (branch, SHA, semver)
  - Cache de Docker layers
  - Manual dispatch para deploys sob demanda
  - Template para deploy SSH (comentado)

#### Configurações
- **Dependabot** (`.github/dependabot.yml`)
  - Atualizações semanais de npm (backend/frontend)
  - Atualizações mensais de GitHub Actions
  - Atualizações semanais de imagens Docker
  - Grupos de dependências (NestJS, Prisma, Next.js, UI)
  - PRs limitadas a 10 por atualização
  - Auto-review e labels

- **Auto-labeling** (`.github/labeler.yml`)
  - Labels automáticas: backend, frontend, docker, ci/cd, documentation
  - Labels por tipo: dependencies, database, tests, enhancement, bug

#### Documentação
- **CI-CD.md**: Guia completo de CI/CD
  - Explicação de cada workflow
  - Exemplos de uso
  - Configuração de secrets
  - Branch protection
  - Troubleshooting
  - Métricas e próximos passos

- **README.md**: Atualizado com
  - Badges de status dos workflows
  - Seção de CI/CD
  - Link para documentação completa

### Changed - Frontend (2025-11-17)

#### Permissões
- `MembersModal.tsx`: 
  - Usuários MEMBER não podem mais ver formulário de convite
  - Apenas OWNER e ADMIN podem convidar novos membros
  - Lógica: `canInviteMembers = currentUserRole === "OWNER" || currentUserRole === "ADMIN"`

### Changed - Docker (2025-11-17)

#### Dockerfiles
- **backend/Dockerfile**:
  - Adicionado DATABASE_URL temporária para `prisma generate`
  - Fix: Permite build sem banco de dados disponível

- **docker-compose.yml**:
  - Removida linha `version` obsoleta
  - Configuração otimizada para desenvolvimento

#### Scripts
- **start.bat**:
  - Adicionado `docker-compose down` antes de subir
  - Fix: Garante que variáveis de ambiente são recarregadas

### Added - Docker (2025-11-17)

#### Documentação
- **DOCKER.md**: Guia completo de Docker
  - Configuração inicial passo a passo
  - Comandos úteis (logs, Prisma, testes)
  - Troubleshooting completo
  - Dicas de hot reload e performance

#### Scripts
- **start.sh**: Script de inicialização para Linux/Mac
- **start.bat**: Script de inicialização para Windows

### Previous Changes

#### Backend
- ✅ Paginação: Suporte completo com page, pageSize, total
- ✅ Convites: Expiração de 7 dias, validação de duplicados
- ✅ Permissões: ADMIN não pode remover OWNER ou outros ADMINs
- ✅ Cleanup: activeCompanyId limpo ao remover usuário
- ✅ Testes: 101 testes passando, cobertura completa
- ✅ Migrations: Migration de expiração de convites aplicada

#### Frontend
- ✅ Paginação: Componente reutilizável, navegação inteligente
- ✅ Dashboard: Atualização automática, mantém página ao editar
- ✅ Modals: Validação de permissões em tempo real

## [1.0.0] - 2025-11-XX

### Versão Inicial
- Sistema de autenticação (JWT)
- Gestão de empresas
- Sistema de convites
- Gerenciamento de membros
- Roles: OWNER, ADMIN, MEMBER

---

## Convenções de Commit

Este projeto usa [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação (não muda código)
- `refactor:` Refatoração
- `perf:` Melhoria de performance
- `test:` Adiciona/corrige testes
- `chore:` Tarefas de build, configs
- `ci:` Mudanças em CI/CD
- `build:` Mudanças no sistema de build
- `revert:` Reverte commit anterior

Exemplo: `feat(backend): adiciona expiração de convites`
