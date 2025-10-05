.PHONY: help install build start start-dev stop test test-e2e test-cov clean docker-build docker-up docker-down docker-logs setup check-deps

# Default target
help:
	@echo "Sales Platform Authentication Service"
	@echo "====================================="
	@echo ""
	@echo "Available commands:"
	@echo "  setup        - Check and install all dependencies"
	@echo "  install      - Install Node.js dependencies"
	@echo "  build        - Build the application"
	@echo "  start        - Start the application"
	@echo "  start-dev    - Start in development mode with hot reload"
	@echo "  test         - Run unit tests"
	@echo "  test-e2e     - Run integration tests"
	@echo "  test-cov     - Run tests with coverage"
	@echo "  lint         - Run ESLint"
	@echo "  format       - Format code with Prettier"
	@echo "  clean        - Clean build artifacts"
	@echo ""
	@echo "Docker commands:"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-up    - Start services with Docker Compose"
	@echo "  docker-down  - Stop Docker services"
	@echo "  docker-test  - Run tests in Docker"
	@echo "  docker-logs  - Show Docker logs"
	@echo ""
	@echo "Utility commands:"
	@echo "  check-deps   - Check if required dependencies are installed"

# Check dependencies
check-deps:
	@echo "Checking required dependencies..."
	@command -v node >/dev/null 2>&1 || { echo "❌ Node.js is required but not installed. Please install Node.js 18+"; exit 1; }
	@command -v npm >/dev/null 2>&1 || { echo "❌ npm is required but not installed. Please install npm"; exit 1; }
	@command -v docker >/dev/null 2>&1 || { echo "❌ Docker is required but not installed. Please install Docker"; exit 1; }
	@command -v docker-compose >/dev/null 2>&1 || command -v docker compose >/dev/null 2>&1 || { echo "❌ Docker Compose is required but not installed. Please install Docker Compose"; exit 1; }
	@echo "✅ All required dependencies are installed"
	@echo ""
	@node --version
	@npm --version
	@docker --version
	@docker-compose --version 2>/dev/null || docker compose version

# Setup project
setup: check-deps
	@echo "Setting up the project..."
	@if [ ! -f .env ]; then \
		echo "📝 Creating .env file from .env.example..."; \
		cp .env.example .env; \
		echo "⚠️  Please update .env file with your configuration"; \
	fi
	@make install
	@echo "✅ Project setup complete!"
	@echo ""
	@echo "Next steps:"
	@echo "1. Update .env file with your Google OAuth credentials"
	@echo "2. Run 'make docker-up' to start the services"
	@echo "3. Run 'make test-e2e' to run integration tests"

# Install dependencies
install:
	@echo "Installing Node.js dependencies..."
	@if [ ! -f package-lock.json ]; then \
		echo "📦 No package-lock.json found, running npm install to generate it..."; \
		npm install; \
	else \
		npm ci; \
	fi

# Build application
build:
	@echo "Building the application..."
	npm run build

# Start application
start:
	@echo "Starting the application..."
	npm run start:prod

# Start in development mode
start-dev:
	@echo "Starting in development mode..."
	npm run start:dev

# Stop application (for development)
stop:
	@echo "Stopping the application..."
	@pkill -f "nest start" || true

# Run unit tests
test:
	@echo "Running unit tests..."
	npm test

# Run integration tests
test-e2e:
	@echo "Running integration tests..."
	npm run test:e2e

# Run tests with coverage
test-cov:
	@echo "Running tests with coverage..."
	npm run test:cov

# Lint code
lint:
	@echo "Running ESLint..."
	npm run lint

# Format code
format:
	@echo "Formatting code..."
	npm run format

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf dist
	rm -rf node_modules
	rm -rf coverage

# Docker commands
docker-build:
	@echo "Building Docker image..."
	docker build -t sales-platform-auth .

docker-up:
	@echo "Starting services with Docker Compose..."
	docker-compose up -d
	@echo "✅ Services started!"
	@echo "API available at: http://localhost:3000"
	@echo "Health check: http://localhost:3000/health"

docker-down:
	@echo "Stopping Docker services..."
	docker-compose down

docker-test:
	@echo "Running tests in Docker..."
	docker-compose up --build test
	docker-compose down

docker-logs:
	@echo "Showing Docker logs..."
	docker-compose logs -f

# Production deployment helpers
docker-prod-up:
	@echo "Starting production services..."
	docker-compose -f docker-compose.yml up -d
	@echo "✅ Production services started!"

docker-prod-down:
	@echo "Stopping production services..."
	docker-compose -f docker-compose.yml down

# Database commands
db-reset:
	@echo "Resetting database..."
	docker-compose down -v
	docker-compose up -d db
	@echo "✅ Database reset complete!"

# Quick development workflow
dev: setup docker-up
	@echo "🚀 Development environment is ready!"
	@echo "API: http://localhost:3000"
	@echo "Health: http://localhost:3000/health"