# Truvami Helm Charts

This repository contains Helm charts for deploying Truvami services in Kubernetes.

## Repository Structure

```
charts/
├── truvami-api/          # Core API service
├── truvami-bridge/       # Message bridge service
├── truvami-dashboard/    # Web dashboard
├── truvami-decoder/      # Data decoder service
├── truvami-gateway/      # Gateway service
├── truvami-siren/        # Alert service
├── truvami-monitoring/   # Monitoring stack (Prometheus, Grafana, AlertManager)
└── truvami-stack/        # Umbrella chart for complete deployment
```

## Quick Start

### Prerequisites

- Kubernetes cluster (1.24+)
- Helm 3.8+
- kubectl configured

### Deploy Complete Stack

```bash
# Add required Helm repositories
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy the complete stack
helm install truvami ./charts/truvami-stack
```

### Deploy Individual Services

```bash
# Deploy just the API
helm install truvami-api ./charts/truvami-api

# Deploy with custom values
helm install truvami-api ./charts/truvami-api -f my-values.yaml
```

## Development

### Prerequisites

- [helm](https://helm.sh/docs/intro/install/)
- [helm-docs](https://github.com/norwoodj/helm-docs) (for documentation generation)
- [yq](https://mikefarah.gitbook.io/yq/) (for YAML processing)

### Linting and Testing

```bash
# Lint all charts
make lint

# Run security analysis
make kube-score

# Check chart versions
make get-versions
```

### CI/CD

This repository includes comprehensive CI checks:

- **Chart Linting**: Validates Helm chart syntax and best practices
- **Security Scanning**: Uses kube-score to identify security issues
- **Breaking Change Detection**: Prevents accidental breaking changes
- **Documentation**: Ensures charts are properly documented

## Chart Documentation

Each chart includes detailed documentation generated from `values.yaml`. See individual chart README files:

- [truvami-api](./charts/truvami-api/README.md)
- [truvami-bridge](./charts/truvami-bridge/README.md)
- [truvami-dashboard](./charts/truvami-dashboard/README.md)
- [truvami-decoder](./charts/truvami-decoder/README.md)
- [truvami-gateway](./charts/truvami-gateway/README.md)
- [truvami-siren](./charts/truvami-siren/README.md)
- [truvami-monitoring](./charts/truvami-monitoring/README.md)
- [truvami-stack](./charts/truvami-stack/README.md)

## Monitoring and Dashboards

The monitoring stack uses **Jsonnet** for maintainable dashboard development:

### Jsonnet-Based Dashboard System

- **Code Reuse**: Shared components across all dashboards
- **Dynamic Generation**: Generate dashboards programmatically
- **Type Safety**: Compile-time validation of dashboard structure
- **Maintainable**: Much easier to read and modify than raw JSON

### Quick Dashboard Development

```bash
# Setup development environment (installs jsonnet, dependencies)
make dev-setup

# Create new service dashboard
./scripts/dashboard-dev.sh new service-my-app

# Build all dashboards from Jsonnet sources
make build-dashboards

# Watch for changes and auto-rebuild during development
./scripts/dashboard-dev.sh watch
```

### Dependency Management

The dashboard system uses optimized dependency management:

- **Lock File**: `jsonnetfile.lock.json` ensures reproducible builds
- **No Committed Dependencies**: `vendor/` directory is gitignored (not committed)
- **CI Caching**: Dependencies are cached in CI for faster builds
- **On-Demand Installation**: Dependencies installed only when needed

```bash
# Install dashboard dependencies manually
make dashboards-deps

# Clean dependencies and generated files
make clean-dashboards
```

**Why this approach?**
- ✅ Keeps repository size small (~160KB saved)
- ✅ Reproducible builds via lock file
- ✅ Faster CI with caching
- ✅ Always uses latest compatible versions

## CI/CD

The repository uses GitHub Actions for automated testing, building, and releasing:

- **Pull Request Checks**: Lint, test, security scans, and dashboard validation
- **Automated Releases**: Tag-based releases with auto-generated changelogs
- **Dependency Caching**: Optimized CI performance with cached dependencies

## Contributing

### Commit Convention

This project follows [Conventional Commits](https://conventionalcommits.org/) for automated changelog generation:

```bash
# Setup commitlint (included in dev-setup)
make pre-commit-setup

# Commit format: type(scope): description
git commit -m "feat(api): add health check endpoint"
git commit -m "fix(monitoring): resolve dashboard layout issue"
git commit -m "docs(readme): update installation guide"
```

**Commit Types:**
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Test additions/updates
- `ci`: CI/CD changes
- `chore`: Maintenance tasks

**Scopes:** `api`, `bridge`, `dashboard`, `decoder`, `gateway`, `siren`, `monitoring`, `stack`, `deps`, `ci`, `docs`, `release`

### Release Process

This repository integrates conventional commits with Helm chart releasing:

```bash
# 1. Update chart versions (if needed)
make update-chart CHART=truvami-api VERSION=0.0.29
git add -A && git commit -m "feat(api): bump version to 0.0.29"

# 2. Generate changelog for unreleased changes
make changelog

# 3. Create a new release (interactive)
make release

# Or specify version directly
./scripts/release.sh --version v1.2.0

# Dry run to see chart changes
./scripts/release.sh --version v1.2.0 --dry-run
```

**Release Workflow:**
1. **Chart versions** updated individually in `Chart.yaml` files
2. **Repository tag** triggers CI to generate changelog and GitHub release
3. **Helm chart releaser** publishes only charts with version changes
4. **Stack dependencies** automatically updated when individual charts change

### Adding New Charts

1. Create chart directory: `charts/new-service/`
2. Use standard Helm chart structure
3. Include comprehensive `values.yaml` with comments
4. Generate documentation: `helm-docs`
5. Test thoroughly with `helm lint` and `helm template`

### Modifying Existing Charts

1. Update chart version following [SemVer](https://semver.org/)
2. Update `CHANGELOG.md` if present
3. Regenerate documentation with `helm-docs`
4. Ensure CI passes

### Dashboard Changes

Service dashboards are now generated from templates. To customize:

1. Modify `charts/truvami-monitoring/values.yaml`
2. Update service definitions or add custom panels
3. Test with `helm template charts/truvami-monitoring`

## Release Process

Charts are automatically released when changes are merged to `main`:

1. CI validates all changes
2. Chart versions are bumped appropriately
3. Charts are packaged and released to GitHub Pages
4. Release notes are generated automatically

## Troubleshooting

### Common Issues

**Chart fails to install**
```bash
# Check template output
helm template my-release ./charts/chart-name

# Validate with dry-run
helm install my-release ./charts/chart-name --dry-run
```

**Dashboard not appearing**
```bash
# Check dashboard configmaps
kubectl get configmaps -l grafana_dashboard=1

# Verify Grafana sidecar is running
kubectl logs deployment/grafana -c grafana-sc-dashboard
```
