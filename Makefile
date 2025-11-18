# Makefile para facilitar comandos Docker

.PHONY: help up down logs build restart clean migrate test

help: ## Mostra esta ajuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Sobe todos os serviços
	docker-compose up -d

down: ## Para todos os serviços
	docker-compose down

logs: ## Mostra logs de todos os serviços
	docker-compose logs -f

logs-backend: ## Mostra logs do backend
	docker-compose logs -f backend

logs-frontend: ## Mostra logs do frontend
	docker-compose logs -f frontend

build: ## Rebuild todos os containers
	docker-compose up -d --build

restart: ## Reinicia todos os serviços
	docker-compose restart

clean: ## Para e remove volumes (CUIDADO: apaga dados)
	docker-compose down -v

migrate: ## Executa migrations do Prisma
	docker-compose exec backend npx prisma migrate deploy

migrate-dev: ## Cria nova migration
	docker-compose exec backend npx prisma migrate dev

studio: ## Abre Prisma Studio
	docker-compose exec backend npx prisma studio

test-backend: ## Roda testes do backend
	docker-compose exec backend npm test

test-frontend: ## Roda testes do frontend
	docker-compose exec frontend npm test

lint-backend: ## Roda lint do backend
	docker-compose exec backend npm run lint

lint-frontend: ## Roda lint do frontend
	docker-compose exec frontend npm run lint

shell-backend: ## Acessa shell do container backend
	docker-compose exec backend sh

shell-frontend: ## Acessa shell do container frontend
	docker-compose exec frontend sh

install: ## Instala dependências em todos os projetos
	cd backend && npm install
	cd frontend && npm install

dev: ## Inicia desenvolvimento local (sem Docker)
	@echo "Iniciando backend e frontend..."
	@cd backend && npm run start:dev & cd frontend && npm run dev
