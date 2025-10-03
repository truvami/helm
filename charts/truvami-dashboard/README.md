# Truvami Dashboard Helm Chart

This Helm chart deploys the Truvami Dashboard application with Better Auth authentication and integrated PostgreSQL database support.

## 🚨 Migration Notice: v1.0.0 Breaking Changes

**Version 1.0.0 introduces breaking changes due to migration from NextAuth.js to Better Auth.**

### Required Actions for Existing Deployments:

1. **Update configuration**: All environment variables have changed
2. **Provide new secrets**: `BETTER_AUTH_SECRET`, `KEYCLOAK_CLIENT_SECRET`
3. **Database migration**: Better Auth uses different tables
4. **Test thoroughly**: Authentication flow has changed

See the [Migration Guide](#migration-from-nextauthjs-to-better-auth) below for detailed instructions.

## Configuration Overview

The chart now uses Better Auth for authentication with the following key components:

- **Better Auth**: Modern authentication library replacing NextAuth.js
- **Keycloak OAuth**: Enterprise SSO integration
- **PostgreSQL**: Database for Better Auth tables and application data
- **API Proxy**: Internal/external API routing

## PostgreSQL Integration

The chart supports two PostgreSQL configurations:

### 1. Managed PostgreSQL (Default)

When `postgres.enabled=true` (default), the chart automatically creates a PostgreSQL cluster using [CloudNativePG](https://cloudnative-pg.io/).

```yaml
postgres:
  enabled: true
  replicaCount: 1
  image:
    repository: ghcr.io/cloudnative-pg/postgresql
    tag: "16.3"
  storage:
    size: 1Gi
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
    requests:
      cpu: 100m
      memory: 256Mi
```

### 2. External PostgreSQL

To use an external PostgreSQL database, set `postgres.enabled=false` and configure the external settings:

```yaml
postgres:
  enabled: false
  external:
    host: "my-postgres-server.example.com"
    port: 5432
    database: "dashboard"
    username: "dashboard"
    password: "secretpassword"
```

### 3. External PostgreSQL with Existing Secret

For better security, you can use an existing Kubernetes secret:

```yaml
postgres:
  enabled: false
  external:
    existingSecret: "my-postgres-secret"
```

The secret should contain the following keys:
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- CloudNativePG operator (if using managed PostgreSQL)

## Installation

1. Add the Truvami Helm repository (if available):
```bash
helm repo add truvami https://charts.truvami.com
helm repo update
```

2. Install the chart:
```bash
helm install my-dashboard truvami/truvami-dashboard
```

3. Or install from source:
```bash
helm install my-dashboard ./charts/truvami-dashboard
```

## Environment Variables

The following database-related environment variables are automatically configured:

- `DATABASE_URL`: Complete PostgreSQL connection string
- `DB_HOST`: Database host
- `DB_PORT`: Database port
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password

## Backup Configuration

When using managed PostgreSQL, you can enable backups to object storage:

```yaml
postgres:
  backup:
    enable: true
    retentionPolicy: "30d"
    barmanObjectStore:
      destinationPath: "s3://my-bucket/backups"
      s3Credentials:
        accessKeyId:
          name: "postgres-backup-secret"
          key: "ACCESS_KEY_ID"
        secretAccessKey:
          name: "postgres-backup-secret"
          key: "SECRET_ACCESS_KEY"
```

## Monitoring

The managed PostgreSQL cluster automatically enables PodMonitor for Prometheus scraping.