# ALTAA - Sistema de Gestão de Empresas

[![CI](https://github.com/Thiago5g/challenge_altaa.ai_monorepo/actions/workflows/ci.yml/badge.svg)](https://github.com/Thiago5g/challenge_altaa.ai_monorepo/actions/workflows/ci.yml)

Sistema completo com backend NestJS e frontend Next.js para gestão de empresas, membros e convites.

## 🚀 Quick Start com Docker (Recomendado)

### Pré-requisitos
- Docker e Docker Compose instalados
- Git

### Rodando tudo de uma vez

1. **Clone e configure**
```powershell
git clone <repo-url>
cd ALTAA
Copy-Item .env.example .env
# Edite o .env com suas configurações (DATABASE_URL, JWT_SECRET)
```

2. **Suba todos os serviços**
```powershell
docker-compose up -d
```

3. **Execute as migrations**
```powershell
docker-compose exec backend npx prisma migrate deploy
```

4. **Acesse as aplicações**
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:4000
- **Swagger Docs**: http://localhost:4000/docs
- **PostgreSQL**: localhost:5432

### Comandos úteis (Make)

```powershell
# Ver todos os comandos disponíveis
make help

# Principais comandos
make up              # Sobe todos os serviços
make down            # Para todos os serviços  
make logs            # Ver logs em tempo real
make logs-backend    # Ver logs do backend
make logs-frontend   # Ver logs do frontend
make restart         # Reinicia tudo
make migrate         # Executa migrations
make studio          # Abre Prisma Studio
make test-backend    # Roda testes do backend
make test-frontend   # Roda testes do frontend
```

### Sem Make (comandos Docker diretos)

```powershell
# Subir serviços
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar
docker-compose down

# Executar migrations
docker-compose exec backend npx prisma migrate deploy

# Rodar testes
docker-compose exec backend npm test
docker-compose exec frontend npm test

# Acessar shell
docker-compose exec backend sh
docker-compose exec frontend sh
```

## 🛠️ Desenvolvimento Local (sem Docker)

### Backend

```powershell
cd backend
npm install
Copy-Item .env.example .env
# Configure DATABASE_URL e JWT_SECRET no .env
npx prisma migrate deploy
npx prisma generate
npm run start:dev
```

Backend rodando em: http://localhost:4000

### Frontend

```powershell
cd frontend
npm install
Copy-Item .env.local.example .env.local
# Configure NEXT_PUBLIC_API_URL=http://localhost:4000
npm run dev
```

Frontend rodando em: http://localhost:3000

## 📦 Estrutura do Projeto

```
ALTAA/
├── backend/              # NestJS API
│   ├── src/
│   │   ├── auth/        # Autenticação JWT
│   │   ├── companies/   # CRUD de empresas
│   │   ├── invites/     # Sistema de convites
│   │   └── prisma/      # Prisma service
│   ├── prisma/
│   │   ├── schema.prisma
│   │   └── migrations/
│   ├── Dockerfile
│   └── package.json
├── frontend/             # Next.js App
│   ├── src/
│   │   ├── app/         # Pages (App Router)
│   │   ├── components/  # UI Components
│   │   ├── services/    # API Services
│   │   └── lib/         # Utilities
│   ├── Dockerfile
│   └── package.json
├── docker-compose.yml    # Orquestração Docker
├── Makefile             # Comandos facilitados
├── .env.example         # Template de variáveis
└── README.md
```

## 🔐 Funcionalidades

### Backend (NestJS + Prisma)
- ✅ **Autenticação**: JWT com bcrypt
- ✅ **Empresas**: CRUD completo com paginação
- ✅ **Membros**: Sistema de roles (OWNER, ADMIN, MEMBER)
- ✅ **Convites**: 
  - Expiração automática (7 dias)
  - Gerenciamento de duplicatas
  - Validações de permissões
- ✅ **Validações**:
  - OWNER não pode ser removido
  - ADMIN não remove OWNER/ADMIN
  - activeCompanyId limpo ao remover membro
- ✅ **Testes**: 101 testes unitários
- ✅ **Documentação**: Swagger/OpenAPI

### Frontend (Next.js + React)
- ✅ **Dashboard**: Listagem de empresas com paginação
- ✅ **Membros**: Gerenciamento completo
- ✅ **Convites**: Aceitar/Recusar convites
- ✅ **UI/UX**: 
  - Modais customizados
  - Toast notifications (Sonner)
  - Design system (shadcn/ui)
- ✅ **Permissões**: Controle por role
- ✅ **Testes**: Cobertura com Jest + RTL

## 🧪 Testes

### Com Docker
```powershell
# Backend (101 testes)
docker-compose exec backend npm test
docker-compose exec backend npm run test:cov

# Frontend
docker-compose exec frontend npm test
docker-compose exec frontend npm run test:coverage
```

### Local
```powershell
# Backend
cd backend
npm test

# Frontend
cd frontend
npm test
```

## 🎯 Stack Tecnológica

### Backend
- **Framework**: NestJS 11
- **ORM**: Prisma 6.19.0
- **Database**: PostgreSQL (Supabase)
- **Auth**: JWT + bcrypt
- **Validation**: class-validator, class-transformer
- **Docs**: Swagger/OpenAPI
- **Tests**: Jest

### Frontend
- **Framework**: Next.js 15 (App Router)
- **UI**: React 19
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 3
- **Components**: shadcn/ui
- **Notifications**: Sonner
- **HTTP**: Fetch API + Zod validation
- **Tests**: Jest + React Testing Library

### DevOps
- **Containers**: Docker + Docker Compose
- **Database**: PostgreSQL 16
- **Node**: 20-alpine

## 🔧 Variáveis de Ambiente

### Backend (.env)
```env
DATABASE_URL=postgresql://user:password@db:5432/altaa_db
JWT_SECRET=seu-secret-super-seguro
NODE_ENV=development
```

### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=http://localhost:4000
```

## 📝 Migrations

```powershell
# Criar nova migration (desenvolvimento)
docker-compose exec backend npx prisma migrate dev --name descricao_mudanca

# Aplicar migrations (produção)
docker-compose exec backend npx prisma migrate deploy

# Abrir Prisma Studio
docker-compose exec backend npx prisma studio
```

## 🚨 Troubleshooting

### Porta já em uso
```powershell
# Verificar o que está usando a porta
netstat -ano | findstr :3000
netstat -ano | findstr :4000

# Matar processo
taskkill /PID <PID> /F
```

### Rebuild containers
```powershell
docker-compose down
docker-compose up -d --build
```

### Limpar volumes (CUIDADO: apaga dados)
```powershell
docker-compose down -v
```

## � CI/CD

Este projeto utiliza GitHub Actions para integração e deploy contínuo.

### Workflows Disponíveis

- **Monorepo CI** (`.github/workflows/ci.yml`): Detecção inteligente de mudanças e execução otimizada
- **Backend CI** (`.github/workflows/backend.yml`): Lint, testes e build do backend
- **Frontend CI** (`.github/workflows/frontend.yml`): Lint e build do frontend
- **Security** (`.github/workflows/security.yml`): Auditoria de segurança semanal
- **PR Checks** (`.github/workflows/pr-checks.yml`): Validações em pull requests
- **Deploy** (`.github/workflows/deploy.yml`): Deploy automático para produção

### Características

✅ **Detecção inteligente**: Apenas roda jobs para código modificado  
✅ **PostgreSQL**: Service container para testes com banco real  
✅ **Cobertura de testes**: Upload automático para Codecov  
✅ **Security scanning**: Trivy para imagens Docker, npm audit  
✅ **Dependabot**: Atualizações automáticas de dependências  
✅ **Auto-labeling**: Labels automáticas em PRs baseadas em arquivos  

### Documentação Completa

📖 Veja [CI-CD.md](./CI-CD.md) para documentação detalhada sobre:
- Como funciona cada workflow
- Configuração de secrets
- Branch protection
- Troubleshooting
- Métricas e monitoramento

## �📄 Licença

Proprietary - Todos os direitos reservados