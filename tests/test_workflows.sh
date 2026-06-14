#!/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_WORKFLOW="$PROJECT_DIR/.github/workflows/release.yml"
CI_WORKFLOW="$PROJECT_DIR/.github/workflows/ci.yml"
SECURITY_WORKFLOW="$PROJECT_DIR/.github/workflows/security.yml"
DEPENDABOT_CONFIG="$PROJECT_DIR/.github/dependabot.yml"

fail() {
    echo "FAIL: $1"
    exit 1
}

require_pattern() {
    local description="$1"
    local pattern="$2"
    local file="${3:-$RELEASE_WORKFLOW}"

    grep -q "$pattern" "$file" || fail "$description"
}

reject_pattern() {
    local description="$1"
    local pattern="$2"
    local path="$3"

    ! grep -R "$pattern" "$path" >/dev/null || fail "$description"
}

test_release_creates_production_deployment() {
    require_pattern "release workflow must request deployment write permission" "deployments: write"
    require_pattern "release workflow must create a GitHub Deployment" "github.rest.repos.createDeployment"
    require_pattern "release workflow must mark the deployment successful" "github.rest.repos.createDeploymentStatus"
    require_pattern "release workflow deployment must target production" "environment: 'production'"
    require_pattern "release workflow deployment must link to the release" "environment_url:"
    require_pattern "release workflow deployment must be skipped for dry runs" "github.event.inputs.dry_run != 'true'"
}

test_security_automation_is_configured() {
    [[ -f "$DEPENDABOT_CONFIG" ]] || fail "Dependabot config must exist"
    require_pattern "Dependabot must monitor GitHub Actions" "package-ecosystem: \"github-actions\"" "$DEPENDABOT_CONFIG"
    require_pattern "Dependabot must monitor the repository root" "directory: \"/\"" "$DEPENDABOT_CONFIG"
    require_pattern "CI workflow must pin minimal read permissions" "contents: read" "$CI_WORKFLOW"
    require_pattern "Security workflow must upload SARIF results" "github/codeql-action/upload-sarif" "$SECURITY_WORKFLOW"
    require_pattern "Security workflow must run gitleaks" "gitleaks/gitleaks-action" "$SECURITY_WORKFLOW"
    reject_pattern "Workflows must not use floating @master actions" "@master" "$PROJECT_DIR/.github/workflows"
}

test_release_creates_production_deployment
test_security_automation_is_configured

echo "Workflow tests passed"
