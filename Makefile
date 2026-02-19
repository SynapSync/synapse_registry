.PHONY: help version release release-dry-run _release

# ─── Colors ──────────────────────────────────────────────────────────────────
BLUE    := \033[1;34m
GREEN   := \033[1;32m
YELLOW  := \033[1;33m
MAGENTA := \033[1;35m
CYAN    := \033[1;36m
RED     := \033[1;31m
RESET   := \033[0m
BOLD    := \033[1m
DIM     := \033[2m

# ─── Divider ─────────────────────────────────────────────────────────────────
DIVIDER := ════════════════════════════════════════════════════════════════

# ─── Default ─────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "$(BOLD)$(CYAN)synapse-registry targets:$(RESET)"
	@echo ""
	@echo "  $(GREEN)make release$(RESET)              Create a new release (bump → tag → push)"
	@echo "  $(GREEN)make release-dry-run$(RESET)      Preview release without making any changes"
	@echo "  $(GREEN)make version$(RESET)              Show current registry version"
	@echo ""

# ─── Show current version ───────────────────────────────────────────────────
version:
	@echo ""; \
	V=$$(node -p "require('./registry.json').version"); \
	echo "  $(MAGENTA)➜ Current version: $(BOLD)v$$V$(RESET)"; \
	echo ""

# ─── Public targets ─────────────────────────────────────────────────────────
release:
	@$(MAKE) --no-print-directory _release DRY_RUN=false

release-dry-run:
	@$(MAKE) --no-print-directory _release DRY_RUN=true

# ─── Internal release pipeline ──────────────────────────────────────────────
_release:
	@set -e; \
	\
	CURRENT=$$(node -p "require('./registry.json').version"); \
	MAJOR=$$(echo $$CURRENT | cut -d. -f1); \
	MINOR=$$(echo $$CURRENT | cut -d. -f2); \
	PATCH=$$(echo $$CURRENT | cut -d. -f3); \
	NEXT_PATCH="$$MAJOR.$$MINOR.$$((PATCH + 1))"; \
	NEXT_MINOR="$$MAJOR.$$((MINOR + 1)).0"; \
	NEXT_MAJOR="$$((MAJOR + 1)).0.0"; \
	\
	echo ""; \
	echo "$(BOLD)$(CYAN)$(DIVIDER)$(RESET)"; \
	echo "$(BOLD)$(CYAN)  🏷️  RELEASE SYNAPSE REGISTRY$(RESET)"; \
	echo "$(BOLD)$(CYAN)$(DIVIDER)$(RESET)"; \
	echo ""; \
	echo "  $(MAGENTA)➜ Current version: $(BOLD)v$$CURRENT$(RESET)"; \
	echo ""; \
	echo "  $(BOLD)Select version bump type:$(RESET)"; \
	echo ""; \
	echo "    $(GREEN)1)$(RESET) patch   ($$CURRENT → $$NEXT_PATCH)"; \
	echo "    $(GREEN)2)$(RESET) minor   ($$CURRENT → $$NEXT_MINOR)"; \
	echo "    $(GREEN)3)$(RESET) major   ($$CURRENT → $$NEXT_MAJOR)"; \
	echo "    $(GREEN)4)$(RESET) custom  (enter specific version)"; \
	echo ""; \
	printf "  $(CYAN)➜ Choose [1-4]: $(RESET)"; \
	read choice; \
	case $$choice in \
		1) NEW_VERSION=$$NEXT_PATCH ;; \
		2) NEW_VERSION=$$NEXT_MINOR ;; \
		3) NEW_VERSION=$$NEXT_MAJOR ;; \
		4) printf "  $(CYAN)  Enter version (e.g., 2.0.0): $(RESET)"; read NEW_VERSION ;; \
		*) echo ""; echo "  $(RED)✗ Invalid option. Aborting.$(RESET)"; echo ""; exit 1 ;; \
	esac; \
	\
	echo ""; \
	\
	if git tag -l "v$$NEW_VERSION" | grep -q .; then \
		echo "  $(RED)✗ Tag v$$NEW_VERSION already exists. Aborting.$(RESET)"; \
		echo ""; \
		exit 1; \
	fi; \
	\
	echo "$(BOLD)$(BLUE)$(DIVIDER)$(RESET)"; \
	echo "$(BOLD)$(BLUE)  📦 BUMPING VERSION$(RESET)"; \
	echo "$(BOLD)$(BLUE)$(DIVIDER)$(RESET)"; \
	echo ""; \
	echo "  $(CYAN)⚙️  Updating registry.json →  v$$NEW_VERSION$(RESET)"; \
	node -e " \
		const fs = require('fs'); \
		const reg = JSON.parse(fs.readFileSync('registry.json', 'utf8')); \
		reg.version = '$$NEW_VERSION'; \
		reg.lastUpdated = new Date().toISOString().split('T')[0] + 'T00:00:00Z'; \
		fs.writeFileSync('registry.json', JSON.stringify(reg, null, 2) + '\n'); \
	"; \
	echo "  $(GREEN)✓ Version bumped to v$$NEW_VERSION$(RESET)"; \
	echo ""; \
	\
	if [ "$(DRY_RUN)" = "true" ]; then \
		echo "$(BOLD)$(YELLOW)$(DIVIDER)$(RESET)"; \
		echo "$(BOLD)$(YELLOW)  ⚠️  DRY RUN — NO CHANGES WILL BE COMMITTED$(RESET)"; \
		echo "$(BOLD)$(YELLOW)$(DIVIDER)$(RESET)"; \
		echo ""; \
		echo "  $(CYAN)Files changed:$(RESET)"; \
		git diff --stat; \
		echo ""; \
		echo "  $(CYAN)Commit message:$(RESET)  chore(release): v$$NEW_VERSION"; \
		echo "  $(CYAN)Tag:$(RESET)             v$$NEW_VERSION"; \
		echo ""; \
		echo "  $(YELLOW)↩️  Rolling back changes...$(RESET)"; \
		git checkout -- registry.json; \
		echo "  $(GREEN)✓ Dry run complete — no changes persisted$(RESET)"; \
		echo ""; \
	else \
		echo "$(BOLD)$(BLUE)$(DIVIDER)$(RESET)"; \
		echo "$(BOLD)$(BLUE)  💾 GIT OPERATIONS$(RESET)"; \
		echo "$(BOLD)$(BLUE)$(DIVIDER)$(RESET)"; \
		echo ""; \
		echo "  $(CYAN)💾 Staging release files...$(RESET)"; \
		git add registry.json; \
		echo "  $(CYAN)💾 Committing: chore(release): v$$NEW_VERSION$(RESET)"; \
		git commit -m "chore(release): v$$NEW_VERSION"; \
		echo ""; \
		echo "  $(CYAN)🏷️  Creating tag v$$NEW_VERSION...$(RESET)"; \
		git tag "v$$NEW_VERSION"; \
		echo "  $(CYAN)💾 Pushing commits...$(RESET)"; \
		git push; \
		echo "  $(CYAN)🏷️  Pushing tag v$$NEW_VERSION...$(RESET)"; \
		git push origin "v$$NEW_VERSION"; \
		echo ""; \
		echo "$(BOLD)$(GREEN)$(DIVIDER)$(RESET)"; \
		echo "$(BOLD)$(GREEN)  ✅ v$$NEW_VERSION RELEASED & TAGGED!$(RESET)"; \
		echo "$(BOLD)$(GREEN)$(DIVIDER)$(RESET)"; \
		echo ""; \
	fi
