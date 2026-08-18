#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
chart="$repo_root/charts/truvami-seedbox"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

uuid="00000000-0000-4000-8000-000000000001"

cat > "$tmp/inline.yaml" <<EOF
seedbox:
  producer:
    maps:
      path: /custom-maps
maps:
  enabled: true
  customerUUID: "$uuid"
  mountPath: /custom-maps
  data:
    preset.yaml: |
      layers: {}
EOF

helm template test "$chart" -f "$tmp/inline.yaml" > "$tmp/inline-rendered.yaml"
grep -Fq "mountPath: \"/custom-maps/$uuid\"" "$tmp/inline-rendered.yaml"
grep -Fq "checksum/maps:" "$tmp/inline-rendered.yaml"
test "$(grep -Fc "checksum/maps:" "$tmp/inline-rendered.yaml")" -eq 1

helm template test "$chart" -f "$tmp/inline.yaml" \
  --show-only templates/configmap.yaml > "$tmp/app-config.yaml"
! grep -Fq "customerUUID:" "$tmp/app-config.yaml"
! grep -Fq "files:" "$tmp/app-config.yaml"

if helm template test "$chart" -f "$tmp/inline.yaml" \
  --set seedbox.producer.maps.path=/maps > /dev/null 2> "$tmp/path-error"; then
  echo "expected mismatched map paths to fail" >&2
  exit 1
fi
grep -Fq "maps.mountPath (/custom-maps) must match seedbox.producer.maps.path (/maps)" "$tmp/path-error"

if helm template test "$chart" \
  --set-string seedbox.producer.maps.customerUUID="$uuid" > /dev/null 2> "$tmp/nested-error"; then
  echo "expected nested deployment map settings to fail" >&2
  exit 1
fi
grep -Fq "move deployment map settings to top-level maps" "$tmp/nested-error"

if helm template test "$chart" \
  --set maps.enabled=true \
  --set maps.customerUUID="$uuid" > /dev/null 2> "$tmp/empty-error"; then
  echo "expected chart-managed maps without files to fail" >&2
  exit 1
fi
grep -Fq "maps.data is required for chart-managed maps" "$tmp/empty-error"

if helm template test "$chart" \
  --set maps.enabled=true \
  --set maps.customerUUID="$uuid" \
  --set-string maps.data.a.csv=content > /dev/null 2> "$tmp/preset-error"; then
  echo "expected chart-managed maps without preset.yaml to fail" >&2
  exit 1
fi
grep -Fq "maps.data must contain preset.yaml" "$tmp/preset-error"

helm template test "$chart" \
  --set maps.enabled=true \
  --set maps.customerUUID="$uuid" \
  --set maps.mountPath=/external-maps \
  --set seedbox.producer.maps.path=/external-maps \
  --set maps.existingConfigMap=external-maps \
  --set-string 'podAnnotations.checksum/maps=external-v2' > "$tmp/external-rendered.yaml"
grep -Fq "mountPath: \"/external-maps/$uuid\"" "$tmp/external-rendered.yaml"
grep -Fq "name: external-maps" "$tmp/external-rendered.yaml"
grep -Fq "checksum/maps: external-v2" "$tmp/external-rendered.yaml"
test "$(grep -Fc "checksum/maps:" "$tmp/external-rendered.yaml")" -eq 1

echo "seedbox maps render checks passed"
