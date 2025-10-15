# Contributing to Truvami Helm Charts

Thank you for your interest in contributing to the Truvami Helm Charts repository! This document provides guidelines and information for contributors.

## Table of Contents

- [Development Setup](#development-setup)
- [Chart Standards](#chart-standards)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## Development Setup

### Prerequisites

Install the required tools:

```bash
# Helm
curl https://get.helm.sh/helm-v3.14.0-darwin-amd64.tar.gz | tar -xzO darwin-amd64/helm > /usr/local/bin/helm && chmod +x /usr/local/bin/helm

# yq (YAML processor)
brew install yq

# helm-docs (documentation generator)
GO111MODULE=on go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest

# kube-score (security analysis)
brew install kube-score

# pre-commit (optional but recommended)
pip install pre-commit
```

### Repository Setup

1. Fork and clone the repository
2. Set up development environment:

```bash
make dev-setup
```

3. Install pre-commit hooks (optional):

```bash
pre-commit install
```

## Chart Standards

### Directory Structure

Each chart should follow this structure:

```
charts/service-name/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default values
├── README.md           # Generated documentation
├── CHANGELOG.md        # Version history (optional)
└── templates/
    ├── _helpers.tpl    # Template helpers
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml    # If applicable
    ├── configmap.yaml  # If applicable
    ├── secret.yaml     # If applicable
    └── tests/          # Chart tests (optional)
```

### Chart.yaml Requirements

```yaml
apiVersion: v2
name: service-name
description: Brief description of the service
type: application
version: 0.1.0         # Chart version (SemVer)
appVersion: "1.0.0"    # App version being deployed
home: https://github.com/truvami/helm
maintainers:
  - name: Truvami Team
    email: dev@truvami.com
```

### Values.yaml Standards

All charts should include these common sections:

```yaml
# Deployment configuration
replicaCount: 1

image:
  repository: service-name
  pullPolicy: IfNotPresent
  tag: ""  # Defaults to Chart.appVersion

# Service configuration
service:
  type: ClusterIP
  port: 80

# Resources
resources: {}
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 128Mi

# Security
securityContext: {}
podSecurityContext: {}

# Scaling
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80

# Common labels
nameOverride: ""
fullnameOverride: ""

# Pod annotations
podAnnotations: {}

# Node selection
nodeSelector: {}
tolerations: []
affinity: {}
```

## Making Changes

### Conventional Commits

We use [Conventional Commits](https://conventionalcommits.org/) for structured commit messages that enable automated changelog generation:

```bash
# Format: type(scope): description
git commit -m "feat(monitoring): add new alert rules"
git commit -m "fix(api): resolve startup issue"
git commit -m "docs(readme): update installation steps"
```

**Commit Types:**
- `feat`: New features → "Features" in changelog
- `fix`: Bug fixes → "Fixes" in changelog
- `docs`: Documentation → "Documentation" in changelog
- `refactor`: Code refactoring → "Refactors" in changelog
- `perf`: Performance → "Performance" in changelog
- `test`: Tests → "Tests" in changelog
- `ci`: CI/CD changes → "CI" in changelog
- `chore`: Maintenance → (skipped)
- `style`: Code style → (skipped)

**Scopes:** `api`, `bridge`, `dashboard`, `decoder`, `gateway`, `siren`, `monitoring`, `stack`, `deps`, `ci`, `docs`, `release`

Pre-commit hooks will validate your commit messages automatically.

### Adding a New Chart

1. Create the chart structure:

```bash
helm create charts/new-service
```

2. Standardize the chart:

```bash
./scripts/standardize-charts.sh new-service
```

3. Customize templates and values as needed

4. Generate documentation:

```bash
make docs
```

### Modifying Existing Charts

1. **Version Bump**: Always increment the chart version in `Chart.yaml`
   - Patch version (0.1.0 → 0.1.1): Bug fixes, no breaking changes
   - Minor version (0.1.0 → 0.2.0): New features, backward compatible
   - Major version (0.1.0 → 1.0.0): Breaking changes

2. **Update Documentation**: Regenerate docs after changes:

```bash
make docs
```

3. **Test Changes**: Run comprehensive tests:

```bash
make check
```

### Dashboard Changes

For monitoring dashboards:

1. **Service Dashboards**: Modify `charts/truvami-monitoring/values.yaml`
2. **General Dashboards**: Use the migration script:

```bash
./scripts/migrate-dashboards.sh
```

3. **Test Dashboard Generation**:

```bash
helm template charts/truvami-monitoring
```

## Testing

### Local Testing

```bash
# Lint all charts
make lint

# Run security analysis
make security

# Test template generation
make test

# Full validation
make check
```

### Specific Chart Testing

```bash
# Lint specific chart
helm lint charts/service-name

# Test template generation
helm template test-release charts/service-name

# Validate with dry-run
helm install test-release charts/service-name --dry-run
```

### Integration Testing

The CI pipeline runs comprehensive tests:

- Chart linting and validation
- Security analysis with kube-score
- Breaking change detection
- Documentation validation
- Template generation tests

## Documentation

### Automatic Generation

Documentation is automatically generated from `values.yaml` comments:

```yaml
# -- Number of replicas for the deployment
replicaCount: 1

image:
  # -- Docker image repository
  repository: service-name
  # -- Image pull policy
  pullPolicy: IfNotPresent
  # -- Image tag (defaults to Chart.appVersion)
  tag: ""
```

### Manual Updates

Update the chart's README.md template if needed:

```bash
# Generate for all charts
make docs

# Generate for specific chart
helm-docs --chart-search-root charts/service-name
```

## Pull Request Process

### Before Submitting

1. **Test Your Changes**:
   ```bash
   make check
   ```

2. **Update Documentation**:
   ```bash
   make docs
   ```

3. **Commit Message Format**:
   ```
   type(scope): description

   [type]: feat, fix, docs, style, refactor, test, chore
   [scope]: chart name or 'ci', 'docs', etc.

   Examples:
   - feat(truvami-api): add health check probes
   - fix(monitoring): correct dashboard template syntax
   - docs: update contributing guidelines
   ```

### PR Requirements

- [ ] Chart version bumped appropriately
- [ ] Tests pass (`make check`)
- [ ] Documentation updated
- [ ] Clear description of changes
- [ ] Breaking changes documented

### Review Process

1. Automated CI checks must pass
2. Code review by maintainers
3. Manual testing if needed
4. Approval and merge

## Release Process

### Automatic Releases

Charts are automatically released when merged to `main`:

1. CI validates all changes
2. Charts are packaged
3. GitHub Pages are updated
4. Release notes generated

### Manual Releases

For hotfixes or special releases:

```bash
# Create release branch
git checkout -b release/chart-name-v1.2.3

# Update version and commit
git commit -am "release: chart-name v1.2.3"

# Create PR to main
```

## Best Practices

### Security

- Always define resource limits
- Use non-root containers when possible
- Implement proper RBAC
- Use secrets for sensitive data
- Enable security contexts

### Performance

- Set appropriate resource requests/limits
- Configure probes (readiness, liveness)
- Use horizontal pod autoscaling when needed
- Optimize container images

### Maintainability

- Use consistent naming conventions
- Add comprehensive comments to values.yaml
- Follow DRY principles with _helpers.tpl
- Keep templates simple and readable

### Monitoring

- Include ServiceMonitor for Prometheus
- Add standardized labels and annotations
- Provide dashboard templates
- Set up proper alerting rules

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/truvami/helm/issues)
- **Discussions**: [GitHub Discussions](https://github.com/truvami/helm/discussions)
- **Documentation**: Check individual chart README files
- **Slack**: #helm-charts channel (internal)

## License

By contributing to this repository, you agree that your contributions will be licensed under the same license as the project.
