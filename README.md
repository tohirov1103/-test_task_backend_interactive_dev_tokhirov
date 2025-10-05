# Sales Platform Authentication Service

A production-ready authentication service built with NestJS, TypeScript, and PostgreSQL. This service provides secure user authentication with email/password and social login support, designed for the Sales Platform ecosystem.

## Features

### 🔐 Authentication Methods
- **Email/Password Authentication** - Secure password hashing with bcrypt
- **Google OAuth 2.0** - Social login integration
- **JWT Token Management** - Stateless authentication with secure tokens
- **Session Management** - Cross-device single sign-on (SSO)

### 🛡️ Security
- **Password Security** - bcrypt hashing with configurable salt rounds
- **Rate Limiting** - Protection against brute force attacks
- **CORS Protection** - Configurable cross-origin resource sharing
- **Security Headers** - XSS, CSRF, and clickjacking protection
- **Input Validation** - Comprehensive request validation
- **SQL Injection Prevention** - TypeORM parameterized queries

### 👤 User Management
- **User Profiles** - Name, email, and profile picture storage
- **Account Management** - User registration, login, and profile updates
- **Provider Linking** - Support for multiple authentication providers
- **Account Status** - Active/inactive user management

### 🧪 Testing & Quality
- **Integration Tests** - Comprehensive E2E test coverage
- **Test Isolation** - Separate test database and containers
- **Code Coverage** - Jest-based test coverage reporting
- **TypeScript** - Full type safety and modern JavaScript features

## Tech Stack

- **Backend**: Node.js 18+ with TypeScript
- **Framework**: NestJS (Express-based)
- **Database**: PostgreSQL 15
- **Authentication**: Passport.js with JWT and OAuth 2.0
- **Testing**: Jest + Supertest
- **Containerization**: Docker & Docker Compose
- **Process Management**: PM2 (production)

## Quick Start

### Prerequisites

Ensure you have the following installed:
- **Node.js** 18+ and npm
- **Docker** and Docker Compose
- **Git**

### 1. Setup Project

```bash
# Clone and setup
git clone <repository-url>
cd sales-platform-auth

# Check dependencies and setup project
make setup
```

### 2. Configure Environment

Update the `.env` file with your configuration:

```bash
# Copy example and edit
cp .env.example .env
```

**Required Environment Variables:**
```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your-secure-password
DB_NAME=sales_platform_auth

# JWT
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters
JWT_EXPIRES_IN=1d

# Google OAuth (required for social login)
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# Frontend URL (for CORS and redirects)
FRONTEND_URL=http://localhost:3001
```

### 3. Start Services

```bash
# Start with Docker Compose (recommended)
make docker-up

# Or start locally (requires local PostgreSQL)
npm run start:dev
```

The API will be available at `http://localhost:3000`

### 4. Verify Installation

```bash
# Health check
curl http://localhost:3000/health

# API documentation
curl http://localhost:3000
```

## API Endpoints

### Authentication

| Method | Endpoint | Description | Authentication |
|--------|----------|-------------|----------------|
| POST | `/auth/register` | Register new user | Public |
| POST | `/auth/login` | Login with email/password | Public |
| GET | `/auth/profile` | Get user profile | JWT Required |
| POST | `/auth/logout` | Logout user | JWT Required |
| GET | `/auth/google` | Initiate Google OAuth | Public |
| GET | `/auth/google/callback` | Google OAuth callback | Public |

### Users

| Method | Endpoint | Description | Authentication |
|--------|----------|-------------|----------------|
| GET | `/users/profile` | Get current user profile | JWT Required |
| PATCH | `/users/profile` | Update user profile | JWT Required |
| GET | `/users` | List all users (admin) | JWT Required |

### Examples

**Register User:**
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepassword123",
    "name": "John Doe"
  }'
```

**Login:**
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepassword123"
  }'
```

**Get Profile:**
```bash
curl -X GET http://localhost:3000/auth/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Development

### Available Commands

```bash
# Development workflow
make help              # Show all available commands
make setup             # Setup project and dependencies
make start-dev         # Start in development mode
make test              # Run unit tests
make test-e2e          # Run integration tests
make lint              # Run code linting
make format            # Format code

# Docker workflow
make docker-up         # Start all services
make docker-down       # Stop all services
make docker-test       # Run tests in Docker
make docker-logs       # View logs
```

### Project Structure

```
src/
├── auth/                 # Authentication module
│   ├── dto/             # Data transfer objects
│   ├── guards/          # Authentication guards
│   ├── strategies/      # Passport strategies
│   ├── auth.controller.ts
│   ├── auth.service.ts
│   └── auth.module.ts
├── users/               # User management module
│   ├── dto/
│   ├── entities/
│   ├── users.controller.ts
│   ├── users.service.ts
│   └── users.module.ts
├── config/              # Configuration
│   └── database.config.ts
├── common/              # Shared utilities
│   └── middleware/
├── app.module.ts        # Main application module
└── main.ts             # Application entry point

test/                    # Integration tests
scripts/                 # Database scripts
```

### Running Tests

```bash
# Run all tests
make test

# Run integration tests
make test-e2e

# Run tests with coverage
npm run test:cov

# Run tests in Docker (isolated)
make docker-test
```

### Database Management

```bash
# Reset database
make db-reset

# View database logs
make docker-logs

# Connect to database
docker-compose exec db psql -U postgres -d sales_platform_auth
```

## Production Deployment

### Docker Production Setup

1. **Build production image:**
```bash
docker build -t sales-platform-auth:latest .
```

2. **Deploy with Docker Compose:**
```bash
# Update environment variables for production
docker-compose -f docker-compose.yml up -d
```

3. **Environment variables for production:**
```env
NODE_ENV=production
JWT_SECRET=use-a-very-long-and-secure-secret-key
DB_PASSWORD=use-a-strong-database-password
# Add your production database and OAuth credentials
```

### Security Checklist for Production

- [ ] Update all default passwords and secrets
- [ ] Configure proper CORS origins
- [ ] Set up SSL/TLS certificates
- [ ] Configure firewall rules
- [ ] Set up monitoring and logging
- [ ] Regular security updates
- [ ] Database backups
- [ ] Rate limiting configuration

## Monitoring and Observability

### Health Checks

- **Application Health**: `GET /health`
- **Database Health**: Included in Docker health checks
- **Container Health**: Docker health check configured

### Logging

The application includes structured logging for:
- Authentication events
- Security events
- Error tracking
- Performance metrics

### Recommended Production Monitoring

- **Application Performance**: New Relic, DataDog
- **Error Tracking**: Sentry
- **Infrastructure**: Prometheus + Grafana
- **Log Aggregation**: ELK Stack or Datadog Logs

## Troubleshooting

### Common Issues

**Database Connection Failed:**
```bash
# Check database status
make docker-logs
docker-compose ps

# Reset database
make db-reset
```

**Authentication Not Working:**
```bash
# Verify JWT secret is set
grep JWT_SECRET .env

# Check token format
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:3000/auth/profile
```

**Tests Failing:**
```bash
# Run tests in clean environment
make docker-test

# Check test database
docker-compose logs test-db
```

**Google OAuth Issues:**
1. Verify Google Console setup
2. Check redirect URLs match exactly
3. Ensure client ID/secret are correct

### Debug Mode

```bash
# Start with debug logging
npm run start:debug

# View detailed logs
make docker-logs
```

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Make changes and add tests
4. Run tests: `make test-e2e`
5. Submit pull request

### Code Standards

- Follow TypeScript best practices
- Maintain test coverage above 80%
- Use conventional commit messages
- Update documentation for new features

## Security

### Reporting Security Issues

Please report security vulnerabilities to: security@salesplatform.com

### Security Features

- Password hashing with bcrypt (12 rounds)
- JWT tokens with configurable expiration
- Rate limiting (10 requests/minute by default)
- Security headers (XSS, CSRF, etc.)
- Input validation and sanitization
- SQL injection prevention

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Documentation**: [DESIGN.md](DESIGN.md)
- **Issues**: GitHub Issues
- **Email**: support@salesplatform.com

---

**Built with ❤️ for the Sales Platform team**