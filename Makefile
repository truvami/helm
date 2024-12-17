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