#!/bin/bash

echo "🚀 Iniciando ALTAA - Full Stack Application"
echo ""

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker não está rodando. Por favor, inicie o Docker Desktop."
  exit 1
fi

echo "✅ Docker está rodando"
echo ""

# Verificar se .env existe
if [ ! -f .env ]; then
  echo "📝 Criando arquivo .env..."
  cp .env.example .env
  echo "⚠️  Por favor, edite o arquivo .env com suas configurações antes de continuar."
  echo "   Especialmente: DATABASE_URL e JWT_SECRET"
  exit 1
fi

echo "✅ Arquivo .env encontrado"
echo ""

# Build e subir containers
echo "🔨 Buildando e subindo containers..."
docker-compose up -d --build

echo ""
echo "⏳ Aguardando serviços ficarem prontos..."
sleep 10

# Executar migrations
echo ""
echo "📊 Executando migrations do banco de dados..."
docker-compose exec -T backend npx prisma migrate deploy

echo ""
echo "✅ Tudo pronto!"
echo ""
echo "📱 Aplicações disponíveis:"
echo "   Frontend:  http://localhost:3000"
echo "   Backend:   http://localhost:4000"
echo "   Swagger:   http://localhost:4000/docs"
echo "   Database:  localhost:5432"
echo ""
echo "📋 Comandos úteis:"
echo "   Ver logs:        docker-compose logs -f"
echo "   Parar tudo:      docker-compose down"
echo "   Prisma Studio:   docker-compose exec backend npx prisma studio"
echo ""
