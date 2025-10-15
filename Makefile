get-versions:
	@printf "%-24s%-24s%-8s%-18s%-18s%-14s\n" "Chart" "Name" "Version" "AppVersion" "UpstreamVersion" "Released"; \
	for chart in $$(ls ./charts); do \
		name=$$(yq eval '.name' ./charts/$$chart/Chart.yaml); \
		version=$$(yq eval '.version' ./charts/$$chart/Chart.yaml); \
		appVersion=$$(yq eval '.appVersion' ./charts/$$chart/Chart.yaml); \
		upstreamVersion=$$(helm search repo truvami/$$chart --versions | awk '/truvami\/'"$$chart"'/{latest=$$2} END{print latest}'); \
		versionMatch=$$(if [[ "$$version" == "$$upstreamVersion" ]]; then echo "✅"; else echo "❌"; fi); \
		printf "%-24s%-24s%-8s%-18s%-18s%-14s\n" "$$chart" "$$name" "$$version" "$$appVersion" "$$upstreamVersion" "$$versionMatch"; \
	done

lint:
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

kube-score:
	@for chart in $$(ls ./charts); do \
		helm template ./charts/$$chart | kube-score score -; \
		echo; \
	done

build-stack:
	helm dep up ./charts/truvami-stack

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

.PHONY: get-versions build-stack changelog update-chart release pre-commit-setup
