.PHONY: wheel serve run stop clean help

PORT := 8743
PARSER_REPO := ../apple-health-parser
DIST := dist

wheel: ## Build the apple-health-parser wheel from the sibling repo checkout, for local dev
	cd $(PARSER_REPO) && uv build --system-certs --wheel --out-dir $(CURDIR)/$(DIST)
	@basename $$(ls -t $(DIST)/*.whl | head -1) > $(DIST)/wheel-filename.txt
	@echo "Built $$(cat $(DIST)/wheel-filename.txt)"

serve: ## Serve this directory at http://localhost:$(PORT) (foreground, Ctrl+C to stop)
	python3 -m http.server $(PORT)

run: wheel ## Build the wheel, serve in the background, and open the page in your browser
	@$(MAKE) stop
	@( python3 -m http.server $(PORT) >/tmp/apple-health-parser-web.log 2>&1 & )
	@sleep 1
	open "http://localhost:$(PORT)/index.html"

stop: ## Stop the background server started by `make run`
	@pkill -f "http.server $(PORT)" || true

clean: ## Remove build artifacts
	rm -rf $(DIST)

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
