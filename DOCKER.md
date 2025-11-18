# 🐳 Guia Docker - ALTAA

## ✅ Configuração Inicial (IMPORTANTE!)

### 1. Configure o arquivo `.env`

```bash
# Copie o exemplo
copy .env.example .env
```

Edite o `.env` e escolha qual banco usar:

**Opção A: Banco Local (Docker)** - Recomendado para desenvolvimento
```env
DATABASE_URL=postgresql://postgres:10203040@db:5432/postgres
```

**Opção B: Supabase (Produção)**
```env
DATABASE_URL=postgresql://postgres:SUA_SENHA@db.gwowagsruidlskhojpal.supabase.co:5432/postgres
```

⚠️ **ATENÇÃO**: Se você mudar o `.env`, precisa recriar os containers:
```bash
docker-compose down
docker-compose up -d
```

### 2. Inicie tudo com um comando

```bash
.\start.bat
```

Ou manualmente:
```bash
docker-compose down         # Para containers existentes
docker-compose up -d        # Sobe os containers
docker-compose exec backend npx prisma migrate deploy  # Aplica migrations
```

## 🎯 Serviços Disponíveis

Após iniciar, você terá acesso a:

- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:4000
- **Swagger/Docs**: http://localhost:4000/docs
- **Database**: localhost:5432

## 📋 Comandos Úteis

### Ver logs
```bash
# Todos os serviços
docker-compose logs -f

# Apenas backend
docker-compose logs -f backend

# Apenas frontend
docker-compose logs -f frontend
```

### Parar/Iniciar
```bash
# Parar tudo
docker-compose down

# Iniciar
docker-compose up -d

# Reiniciar um serviço específico
docker-compose restart backend
```

### Prisma
```bash
# Migrations
docker-compose exec backend npx prisma migrate deploy

# Studio (GUI do banco)
docker-compose exec backend npx prisma studio

# Gerar client
docker-compose exec backend npx prisma generate
```

### Entrar no container
```bash
# Backend
docker-compose exec backend sh

# Frontend
docker-compose exec frontend sh

# Database
docker-compose exec db psql -U postgres
```

### Testes
```bash
# Backend
docker-compose exec backend npm test

# Frontend
docker-compose exec frontend npm test
```

## 🔧 Problemas Comuns

### 1. Erro "Can't reach database server"

**Causa**: DATABASE_URL aponta para lugar errado ou containers foram recriados sem parar antes.

**Solução**:
```bash
# Verifique o .env
type .env | findstr DATABASE

# Recrie os containers
docker-compose down
docker-compose up -d

# Execute as migrations
docker-compose exec backend npx prisma migrate deploy
```

### 2. Mudei o `.env` mas não funciona

**Causa**: Docker Compose lê o `.env` apenas no `up`.

**Solução**:
```bash
docker-compose down
docker-compose up -d
```

### 3. Porta já em uso (3000, 4000 ou 5432)

**Causa**: Outro serviço está usando a porta.

**Solução**:
```bash
# Ver o que está usando a porta 4000
netstat -ano | findstr :4000

# Matar o processo (substitua PID)
taskkill /PID <numero_do_pid> /F
```

### 4. Frontend não conecta no backend

**Causa**: NEXT_PUBLIC_API_URL incorreto.

**Solução**: Verifique no `.env`:
```env
NEXT_PUBLIC_API_URL=http://localhost:4000
```

### 5. Erro no build do Prisma

**Causa**: DATABASE_URL não está definida durante o build.

**Solução**: Já está corrigido no Dockerfile com uma URL temporária.

### 6. Limpar tudo e começar do zero

```bash
# Parar e remover containers, volumes e imagens
docker-compose down -v
docker system prune -a

# Começar novamente
.\start.bat
```

## 🚀 Hot Reload

Os containers estão configurados para **hot reload**:

- **Backend**: Qualquer mudança em `backend/src/**` reinicia automaticamente
- **Frontend**: Qualquer mudança em `frontend/**` recarrega automaticamente

Não precisa recriar os containers ao editar código!

## 📦 Estrutura dos Containers

```
altaa-database (PostgreSQL)
  ↓ depends_on
altaa-backend (NestJS)
  ↓ depends_on
altaa-frontend (Next.js)
```

## 🔐 Variáveis de Ambiente

### Backend
- `DATABASE_URL`: String de conexão PostgreSQL
- `JWT_SECRET`: Segredo para gerar tokens JWT
- `NODE_ENV`: development

### Frontend
- `NEXT_PUBLIC_API_URL`: URL da API (http://localhost:4000)
- `NODE_ENV`: development

### Database
- `POSTGRES_USER`: postgres
- `POSTGRES_PASSWORD`: 10203040
- `POSTGRES_DB`: postgres

## 💡 Dicas

1. **Use `make` se disponível**: Criamos um Makefile com atalhos convenientes
2. **Logs em tempo real**: `docker-compose logs -f` mostra tudo que está acontecendo
3. **Prisma Studio**: Ótimo para visualizar/editar dados: `docker-compose exec backend npx prisma studio`
4. **Performance**: Se estiver lento, ajuste recursos do Docker Desktop (Settings → Resources)

## 📚 Próximos Passos

- [ ] Criar testes E2E
- [ ] Configurar CI/CD
- [ ] Otimizar Dockerfiles para produção
- [ ] Adicionar nginx como reverse proxy
- [ ] Configurar certificados SSL

---

**Problemas?** Verifique os logs: `docker-compose logs -f`
