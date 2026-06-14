#!/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_WORKFLOW="$PROJECT_DIR/.github/workflows/release.yml"

fail() {
    echo "FAIL: $1"
    exit 1
}

require_pattern() {
    local description="$1"
    local pattern="$2"

    grep -q "$pattern" "$RELEASE_WORKFLOW" || fail "$description"
}

test_release_creates_production_deployment() {
    require_pattern "release workflow must request deployment write permission" "deployments: write"
    require_pattern "release workflow must create a GitHub Deployment" "github.rest.repos.createDeployment"
    require_pattern "release workflow must mark the deployment successful" "github.rest.repos.createDeploymentStatus"
    require_pattern "release workflow deployment must target production" "environment: 'production'"
    require_pattern "release workflow deployment must link to the release" "environment_url:"
    require_pattern "release workflow deployment must be skipped for dry runs" "github.event.inputs.dry_run != 'true'"
}

test_release_creates_production_deployment

echo "Workflow tests passed"
