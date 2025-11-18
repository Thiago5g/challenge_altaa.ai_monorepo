# 🚀 CI/CD - Configuração e Documentação

Este documento explica a configuração de CI/CD para o monorepo ALTAA.

## 📋 Workflows Disponíveis

### 1. **Monorepo CI** (`ci.yml`) - Principal ⭐

Workflow inteligente que detecta mudanças e executa apenas os jobs necessários.

**Triggers:**
- Push para `main` ou `develop`
- Pull requests para `main` ou `develop`

**Jobs:**
- ✅ **detect-changes**: Detecta quais partes do código mudaram
- ✅ **backend-ci**: Lint, testes e build do backend (só roda se backend mudou)
- ✅ **frontend-ci**: Lint e build do frontend (só roda se frontend mudou)
- ✅ **docker-build**: Testa build e inicialização do Docker Compose (só roda se Docker mudou)
- ✅ **ci-success**: Job final que verifica se tudo passou

**Exemplo de execução:**
```bash
# Se você mudar apenas backend/src/auth/auth.service.ts:
✓ detect-changes (detecta mudança no backend)
✓ backend-ci (executa)
⊘ frontend-ci (pula)
⊘ docker-build (pula)
✓ ci-success
```

### 2. **Backend CI** (`backend.yml`)

Workflow dedicado ao backend com PostgreSQL.

**Triggers:**
- Push/PR que afete `backend/**`

**Features:**
- ✅ PostgreSQL service rodando durante testes
- ✅ Prisma migrations
- ✅ Testes com coverage
- ✅ Upload de coverage para Codecov

**Comandos executados:**
```bash
npm ci
npx prisma generate
npx prisma migrate deploy
npm run lint
npm test -- --coverage
npm run build
```

### 3. **Frontend CI** (`frontend.yml`)

Workflow dedicado ao frontend.

**Triggers:**
- Push/PR que afete `frontend/**`

**Features:**
- ✅ Type checking (TypeScript)
- ✅ Build do Next.js
- ✅ Verificação de artefatos de build

**Comandos executados:**
```bash
npm ci
npm run lint --if-present
npm run type-check --if-present
npm test --if-present
npm run build
```

### 4. **Deploy** (`deploy.yml`)

Workflow para build e push de imagens Docker.

**Triggers:**
- Push para `main`
- Manual dispatch

**Features:**
- ✅ Build de imagens Docker para backend e frontend
- ✅ Push para GitHub Container Registry (ghcr.io)
- ✅ Tagging automático (branch, SHA, semver)
- ✅ Cache de layers para builds rápidos

**Como usar:**
```bash
# Automático ao fazer push para main
git push origin main

# Ou manual via GitHub UI:
Actions → Deploy to Production → Run workflow
```

### 5. **Security** (`security.yml`)

Workflow de segurança e auditoria.

**Triggers:**
- Toda segunda-feira às 9h UTC (scheduled)
- Manual dispatch

**Features:**
- ✅ Dependency review (em PRs)
- ✅ npm audit (backend e frontend)
- ✅ Check de pacotes desatualizados
- ✅ Trivy scan nas imagens Docker
- ✅ Upload de vulnerabilidades para GitHub Security

### 6. **Dependabot** (`dependabot.yml`)

Atualização automática de dependências.

**Configuração:**
- ✅ Backend npm packages (semanalmente, segundas 9h)
- ✅ Frontend npm packages (semanalmente, segundas 9h)
- ✅ GitHub Actions (mensalmente)
- ✅ Docker base images (semanalmente)

**Grupos de dependências:**
- NestJS packages
- Prisma packages
- Testing packages (Jest, etc)
- Next.js + React
- UI packages (Radix, Tailwind)

## 🎯 Detecção Inteligente de Mudanças

O workflow principal usa `dorny/paths-filter` para detectar mudanças:

```yaml
backend:
  - 'backend/**'
  - 'docker-compose.yml'
  
frontend:
  - 'frontend/**'
  - 'docker-compose.yml'
  
docker:
  - 'docker-compose.yml'
  - '**/Dockerfile'
  - '**/.dockerignore'
```

**Benefícios:**
- ⚡ Builds mais rápidos (só roda o necessário)
- 💰 Economiza minutos de CI
- 🎯 Feedback mais focado

## 🔧 Configuração Necessária

### Secrets do GitHub (opcional para deploy)

Vá em: `Settings → Secrets and variables → Actions`

```bash
# Para deploy automático (quando configurar servidor)
DEPLOY_HOST=seu-servidor.com
DEPLOY_USER=deploy
DEPLOY_KEY=<sua-chave-ssh-privada>

# Para Codecov (opcional)
CODECOV_TOKEN=<seu-token>
```

### Branch Protection

Recomendado para `main` e `develop`:

1. Settings → Branches → Add rule
2. Branch name pattern: `main`
3. ✅ Require status checks to pass
   - ✅ CI Success (do workflow ci.yml)
4. ✅ Require pull request reviews (1 aprovação)
5. ✅ Dismiss stale reviews

## 📊 Status Badges

Adicione ao README.md:

```markdown
[![Monorepo CI](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/ci.yml/badge.svg)](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/ci.yml)
[![Backend CI](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/backend.yml/badge.svg)](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/backend.yml)
[![Frontend CI](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/frontend.yml/badge.svg)](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/frontend.yml)
[![Security](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/security.yml/badge.svg)](https://github.com/Thiago5g/altaa.ai_frontend/actions/workflows/security.yml)
```

## 🚦 Fluxo de Trabalho Recomendado

### Para Features

```bash
# 1. Criar branch
git checkout -b feature/nova-funcionalidade

# 2. Fazer commits
git add .
git commit -m "feat: adiciona nova funcionalidade"

# 3. Push
git push origin feature/nova-funcionalidade

# 4. Criar PR no GitHub
# CI rodará automaticamente (apenas nos arquivos alterados)

# 5. Após aprovação e CI verde, merge para develop
# CI rodará novamente

# 6. Deploy: merge develop → main
# Deploy workflow criará e publicará imagens Docker
```

### Para Hotfixes

```bash
# 1. Branch direto da main
git checkout main
git checkout -b hotfix/correcao-critica

# 2. Fix e commit
git add .
git commit -m "fix: corrige bug crítico"

# 3. Push e PR para main
git push origin hotfix/correcao-critica

# 4. Após merge, deploy automático
```

## 🐛 Troubleshooting

### CI falha no backend com erro de Prisma

**Problema**: `Error: Cannot find module '@prisma/client'`

**Solução**: Já configurado! O workflow roda `npx prisma generate` antes dos testes.

### Docker build falha no CI

**Problema**: `DATABASE_URL is required`

**Solução**: Já configurado! O workflow cria `.env` com valores de teste.

### Testes falhando no CI mas passam local

**Problema**: Diferenças de ambiente

**Solução**: 
```bash
# Rode localmente com as mesmas condições do CI
docker-compose exec backend npm test

# Ou simule o PostgreSQL do CI
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:16-alpine
```

### Dependabot criando muitos PRs

**Problema**: Muitas PRs de dependências

**Solução**: Ajuste em `.github/dependabot.yml`:
```yaml
open-pull-requests-limit: 5  # Reduzir de 10 para 5
```

## 📈 Métricas e Monitoramento

### Ver histórico de CI

```bash
# Via GitHub CLI
gh run list --workflow=ci.yml --limit 10

# Ver detalhes de uma run
gh run view <run-id>

# Ver logs
gh run view <run-id> --log
```

### Tempo médio de CI

- Backend CI: ~3-5 minutos
- Frontend CI: ~2-3 minutos
- Docker Build: ~4-6 minutos
- Total (tudo junto): ~6-8 minutos
- Total (mudanças isoladas): ~2-5 minutos

## 🎓 Próximos Passos

- [ ] Configurar E2E tests com Playwright/Cypress
- [ ] Adicionar smoke tests em produção
- [ ] Configurar deploy automático para staging
- [ ] Adicionar performance benchmarks
- [ ] Configurar Lighthouse CI para frontend
- [ ] Adicionar código coverage mínimo obrigatório

## 📚 Referências

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Dependabot Configuration](https://docs.github.com/en/code-security/dependabot)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [Paths Filter Action](https://github.com/dorny/paths-filter)

---

**Última atualização**: Novembro 2025
**Mantido por**: Equipe ALTAA
