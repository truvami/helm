help: ## Display this help message
	@echo "Truvami Helm Charts - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

get-versions: ## Check chart versions vs published versions
	@printf "%-24s%-24s%-8s%-18s%-18s%-14s\n" "Chart" "Name" "Version" "AppVersion" "UpstreamVersion" "Released"; \
	for chart in $$(ls ./charts); do \
		name=$$(yq eval '.name' ./charts/$$chart/Chart.yaml); \
		version=$$(yq eval '.version' ./charts/$$chart/Chart.yaml); \
		appVersion=$$(yq eval '.appVersion' ./charts/$$chart/Chart.yaml); \
		upstreamVersion=$$(helm search repo truvami/$$chart --versions | awk '/truvami\/'"$$chart"'/{latest=$$2} END{print latest}'); \
		versionMatch=$$(if [[ "$$version" == "$$upstreamVersion" ]]; then echo "✅"; else echo "❌"; fi); \
		printf "%-24s%-24s%-8s%-18s%-18s%-14s\n" "$$chart" "$$name" "$$version" "$$appVersion" "$$upstreamVersion" "$$versionMatch"; \
	done

lint: ## Lint all Helm charts
	@failed_charts=0; \
	for chart in $$(ls ./charts); do \
		if ! helm lint ./charts/$$chart > /dev/null; then \
			helm lint ./charts/$$chart; \
			echo; \
		fi; \
	done; \
	if [ $$failed_charts -eq 0 ]; then \
		echo "All charts are successfully linted. ✅"; \
	fi

kube-score: ## Run kube-score security analysis
	@for chart in $$(ls ./charts); do \
		helm template ./charts/$$chart | kube-score score -; \
		echo; \
	done

build-stack: ## Build stack chart dependencies
	helm dep up ./charts/truvami-stack

# Dashboard Management
install-jsonnet: ## Install jsonnet and jsonnet-bundler
	@echo "🔧 Installing Jsonnet tools..."
	@if ! command -v jsonnet >/dev/null 2>&1; then \
		echo "Installing jsonnet..."; \
		go install github.com/google/go-jsonnet/cmd/jsonnet@latest; \
	fi
	@if ! command -v jb >/dev/null 2>&1; then \
		echo "Installing jsonnet-bundler..."; \
		go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest; \
	fi
	@echo "✅ Jsonnet tools installed"

dashboards-deps: install-jsonnet ## Install dashboard dependencies
	@echo "📦 Installing dashboard dependencies..."
	@cd dashboards && jb install
	@echo "✅ Dashboard dependencies installed"

build-dashboards: dashboards-deps ## Build Grafana dashboards from Jsonnet
	@echo "🏗️  Building dashboards..."
	@mkdir -p charts/truvami-monitoring/dashboards-generated
	@cd dashboards && \
	for jsonnet_file in src/*.jsonnet; do \
		dashboard_name=$$(basename "$$jsonnet_file" .jsonnet); \
		echo "Building $$dashboard_name.json..."; \
		jsonnet -J vendor "$$jsonnet_file" > "../charts/truvami-monitoring/dashboards-generated/$$dashboard_name.json"; \
	done
	@echo "✅ Dashboards built successfully"

validate-dashboards: build-dashboards ## Validate generated dashboards
	@echo "🔍 Validating dashboards..."
	@for dashboard in charts/truvami-monitoring/dashboards-generated/*.json; do \
		echo "Validating $$(basename $$dashboard)..."; \
		if ! python3 -m json.tool "$$dashboard" > /dev/null; then \
			echo "❌ Invalid JSON in $$dashboard"; \
			exit 1; \
		fi; \
	done
	@echo "✅ All dashboards are valid JSON"

clean-dashboards: ## Clean generated dashboards
	@echo "🧹 Cleaning generated dashboards..."
	@rm -rf charts/truvami-monitoring/dashboards-generated
	@echo "✅ Generated dashboards cleaned"

# Release Management
changelog: ## Generate changelog
	@echo "📖 Generating changelog..."
	@./scripts/changelog.sh

update-chart: ## Update chart version (usage: make update-chart CHART=name VERSION=x.y.z)
	@if [ -z "$(CHART)" ] || [ -z "$(VERSION)" ]; then \
		echo "❌ Usage: make update-chart CHART=chart-name VERSION=x.y.z"; \
		echo "   Example: make update-chart CHART=truvami-api VERSION=0.0.29"; \
		exit 1; \
	fi
	@./scripts/update-chart.sh $(CHART) $(VERSION)

release: ## Create a new release (interactive)
	@echo "🚀 Starting release process..."
	@./scripts/release.sh

pre-commit-setup: ## Setup pre-commit hooks
	@echo "🔧 Setting up pre-commit hooks..."
	@if ! command -v pre-commit >/dev/null 2>&1; then \
		echo "❌ pre-commit not found. Install it first:"; \
		echo "   pip install pre-commit"; \
		exit 1; \
	fi
	@pre-commit install
	@echo "✅ Pre-commit hooks installed"

.PHONY: help get-versions lint kube-score build-stack install-jsonnet dashboards-deps build-dashboards validate-dashboards clean-dashboards changelog update-chart release pre-commit-setup
