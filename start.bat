@echo off
echo.
echo ========================================
echo   ALTAA - Full Stack Application
echo ========================================
echo.

REM Verificar se Docker está rodando
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Docker nao esta rodando!
    echo Por favor, inicie o Docker Desktop.
    pause
    exit /b 1
)

echo [OK] Docker esta rodando
echo.

REM Verificar se .env existe
if not exist .env (
    echo [INFO] Criando arquivo .env...
    copy .env.example .env >nul
    echo.
    echo [ATENCAO] Por favor, edite o arquivo .env com suas configuracoes
    echo           Especialmente: DATABASE_URL e JWT_SECRET
    echo.
    pause
    exit /b 1
)

echo [OK] Arquivo .env encontrado
echo.

REM Parar containers existentes (se houver)
echo [INFO] Parando containers existentes...
docker-compose down >nul 2>&1

REM Build e subir containers
echo [INFO] Buildando e subindo containers...
docker-compose up -d --build

echo.
echo [INFO] Aguardando servicos ficarem prontos...
timeout /t 10 /nobreak >nul

REM Executar migrations
echo.
echo [INFO] Executando migrations do banco de dados...
docker-compose exec -T backend npx prisma migrate deploy

echo.
echo ========================================
echo   Tudo pronto!
echo ========================================
echo.
echo Aplicacoes disponiveis:
echo   Frontend:  http://localhost:3000
echo   Backend:   http://localhost:4000
echo   Swagger:   http://localhost:4000/docs
echo   Database:  localhost:5432
echo.
echo Comandos uteis:
echo   Ver logs:        docker-compose logs -f
echo   Parar tudo:      docker-compose down
echo   Prisma Studio:   docker-compose exec backend npx prisma studio
echo.
pause
