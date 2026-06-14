# PortKill Makefile
# Copyright (c) 2025 Abraham Esandayinze Tanta

.PHONY: install uninstall test lint security clean help setup-dev release

# Version information
VERSION := $(shell grep 'readonly VERSION=' bin/portkill | cut -d'"' -f2)
TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)
PREFIX ?= /usr/local
BINDIR := $(PREFIX)/bin

# Default target
all: help

# Installation targets
install:
	@echo "Installing PortKill v$(VERSION)..."
	@mkdir -p $(BINDIR)
	@cp bin/portkill $(BINDIR)/portkill
	@chmod +x $(BINDIR)/portkill
	@echo "✅ PortKill v$(VERSION) installed successfully!"

uninstall:
	@echo "Uninstalling PortKill..."
	@rm -f $(BINDIR)/portkill
	@echo "✅ PortKill uninstalled successfully!"

# Development targets
setup-dev:
	@echo "Setting up development environment..."
	@chmod +x bin/portkill install.sh uninstall.sh tests/test_portkill.sh tests/test_workflows.sh
	@echo "✅ Development environment ready"

test:
	@echo "Running PortKill test suite..."
	@./tests/test_portkill.sh
	@./tests/test_workflows.sh

test-quick:
	@echo "Running quick functionality tests..."
	@./bin/portkill --version > /dev/null && echo "✅ Version command works"
	@./bin/portkill --help > /dev/null && echo "✅ Help command works"
	@./bin/portkill -n list 80 > /dev/null && echo "✅ Dry-run mode works"

lint:
	@echo "Running code quality checks..."
	@command -v shellcheck >/dev/null 2>&1 || (echo "⚠️  ShellCheck not installed" && exit 1)
	@shellcheck bin/portkill install.sh uninstall.sh tests/test_portkill.sh tests/test_workflows.sh
	@echo "✅ Linting completed"

security:
	@echo "Running security checks..."
	@echo "Checking for dangerous patterns..."
	@! grep -r "eval\|system(" bin/ || (echo "❌ Dangerous commands found" && exit 1)
	@echo "Checking for hardcoded secrets..."
	@! grep -r "password\|secret" --include="*.sh" . | grep -v "GITHUB_TOKEN\|secrets\." || (echo "⚠️  Potential secrets found" && exit 1)
	@echo "✅ Security checks passed"

# CI/CD targets
ci-test:
	@echo "Running CI test suite..."
	@$(MAKE) lint
	@$(MAKE) security  
	@$(MAKE) test
	@echo "✅ All CI tests passed"

# Release targets
release-check:
	@echo "Checking release readiness..."
	@git status --porcelain | grep -q . && echo "❌ Working directory not clean" && exit 1 || echo "✅ Working directory clean"
	@$(MAKE) test > /dev/null && echo "✅ Tests pass" || (echo "❌ Tests failed" && exit 1)
	@echo "✅ Ready for release"

release:
	@echo "Creating release..."
	@read -p "Enter version (current: $(VERSION)): " NEW_VERSION; \
	if [ -n "$$NEW_VERSION" ]; then \
		echo "Updating version to $$NEW_VERSION..."; \
		sed -i.bak "s/readonly VERSION=\"[^\"]*\"/readonly VERSION=\"$$NEW_VERSION\"/" bin/portkill; \
		sed -i.bak "s/VERSION=\"[^\"]*\"/VERSION=\"$$NEW_VERSION\"/" install.sh uninstall.sh; \
		rm -f bin/portkill.bak install.sh.bak uninstall.sh.bak; \
		git add bin/portkill install.sh uninstall.sh; \
		git commit -m "chore: bump version to $$NEW_VERSION"; \
		git tag "v$$NEW_VERSION"; \
		echo "✅ Release v$$NEW_VERSION created. Push with: git push origin main --tags"; \
	else \
		echo "❌ Release cancelled"; \
	fi

# Package targets  
package:
	@echo "Creating distribution package..."
	@mkdir -p dist
	@tar --exclude='.git*' --exclude='dist' --exclude='.idea' --exclude='node_modules' \
	    -czf "dist/portkill-$(VERSION)-$(TIMESTAMP).tar.gz" \
	    -C .. $$(basename $$(pwd))
	@echo "✅ Package created: dist/portkill-$(VERSION)-$(TIMESTAMP).tar.gz"

# Cleanup targets
clean:
	@echo "Cleaning up temporary files..."
	@rm -rf dist/
	@rm -f *.bak
	@rm -rf /tmp/portkill-test-*
	@echo "✅ Cleanup completed"

clean-all: clean
	@echo "Deep cleaning..."
	@rm -rf .DS_Store
	@find . -name "*.log" -delete
	@echo "✅ Deep cleanup completed"

# Homebrew targets
brew-test:
	@echo "Testing Homebrew installation..."
	@command -v brew >/dev/null 2>&1 || (echo "❌ Homebrew not installed" && exit 1)
	@brew install --build-from-source mr-tanta/portkill/portkill
	@portkill --version
	@brew uninstall portkill
	@echo "✅ Homebrew installation test completed"

# Documentation targets
docs-check:
	@echo "Checking documentation..."
	@command -v markdownlint >/dev/null 2>&1 || (echo "⚠️  markdownlint not installed" && npm install -g markdownlint-cli)
	@markdownlint README.md CONTRIBUTING.md || true
	@echo "✅ Documentation check completed"

# Development utilities
watch-test:
	@echo "Watching for changes and running tests..."
	@command -v fswatch >/dev/null 2>&1 || (echo "❌ fswatch not installed. Install with: brew install fswatch" && exit 1)
	@fswatch -o bin/portkill tests/ | xargs -n1 -I{} $(MAKE) test-quick

stats:
	@echo "PortKill Statistics"
	@echo "==================="
	@echo "Version: $(VERSION)"
	@echo "Lines of code: $$(wc -l bin/portkill | awk '{print $$1}')"
	@echo "Script size: $$(du -h bin/portkill | awk '{print $$1}')"
	@echo "Test files: $$(find tests/ -name '*.sh' | wc -l | tr -d ' ')"
	@echo "Commits: $$(git rev-list --count HEAD 2>/dev/null || echo 'N/A')"

# Help target
help:
	@echo "PortKill Makefile v$(VERSION)"
	@echo "============================="
	@echo "Installation:"
	@echo "  install      - Install PortKill to $(PREFIX)/bin"
	@echo "  uninstall    - Remove PortKill from system"
	@echo ""
	@echo "Development:"
	@echo "  setup-dev    - Set up development environment"
	@echo "  test         - Run full test suite"
	@echo "  test-quick   - Run quick functionality tests"
	@echo "  lint         - Run code quality checks"
	@echo "  security     - Run security checks"
	@echo "  ci-test      - Run all CI checks"
	@echo ""
	@echo "Release:"
	@echo "  release-check - Check if ready for release"
	@echo "  release      - Create new release"
	@echo "  package      - Create distribution package"
	@echo ""
	@echo "Maintenance:"
	@echo "  clean        - Clean temporary files"
	@echo "  clean-all    - Deep clean all files"
	@echo "  stats        - Show project statistics"
	@echo "  help         - Show this help message"
