.DEFAULT_GOAL := build

# Go variables
GO 							?= go
GO_RELEASER 		?= $(GO_TOOL) github.com/goreleaser/goreleaser/v2
GO_LINT 				?= $(GO_TOOL) github.com/golangci/golangci-lint/v2/cmd/golangci-lint
GO_TOOL 				?= $(GO) tool
GO_TEST 				?= $(GO_TOOL) gotest.tools/gotestsum --format pkgname
GO_HUGO 				?= $(GO_TOOL) github.com/gohugoio/hugo
GO_KIND 				?= $(GO_TOOL) sigs.k8s.io/kind/cmd/kind
GO_K9S 					?= $(GO_TOOL) github.com/derailed/k9s

# HELM
HELM_INDEX 			?= $(GO_TOOL) github.com/zeiss/pkg/cmd/helm/index
HELM_PACKAGE 		?= $(GO_TOOL) github.com/zeiss/pkg/cmd/helm/package
HELM_RELEASE 		?= $(GO_TOOL) github.com/zeiss/pkg/cmd/helm/release
HELM_UPDATE 		?= $(GO_TOOL) github.com/zeiss/pkg/cmd/helm/update

# Variables
DIST 						?= .dist
REPO 					  ?= $(GITHUB_REPO)
TOKEN 					?= $(GITHUB_TOKEN)
CLUSTER_NAME		?= kind-charts-cluster
CLUSTER_CONFIG	?= cluster.yaml

.PHONY: package
package: ## Packaging the helm charts
	$(HELM_PACKAGE) --package-path $(DIST)/staging --path staging/knative
	$(HELM_PACKAGE) --package-path $(DIST)/staging --path staging/eventing
	@echo "✅ Helm charts packaged successfully."

.PHONY: release
release: ## Release the binary file.
	$(HELM_RELEASE) --package-path $(DIST)/staging --repo $(REPO) --token $(TOKEN) --release-name "staging-{{ .Name }}-{{ .Version }}"
	@echo "✅ Helm charts released successfully."

.PHONY: generate
generate: ## Generate code.
	$(GO) generate www
	$(HELM_INDEX) --repo $(REPO) --index www/public/staging/index.yaml --starts-with staging
	$(HELM_INDEX) --repo $(REPO) --index www/public/stable/index.yaml --starts-with stable
	@echo "✅ Helm index generated successfully."

.PHONY: cluster-create
cluster-create: ## Create a local Kubernetes cluster using kind.
	$(GO_KIND) create cluster --config $(CLUSTER_CONFIG)
	@echo "✅ Kind cluster created successfully."

.PHONY: cluster-delete
cluster-delete: ## Destroy the local Kubernetes cluster using kind.
	$(GO_KIND) delete cluster --name $(CLUSTER_NAME)
	@echo "✅ Kind cluster destroyed successfully."

.PHONY: k9s
k9s: ## Open k9s dashboard.
	$(GO_K9S)

.PHONY: clean
clean: ## Remove previous build.
	@rm -rf .dist
	@find . -type f -name '*.gen.go' -exec rm {} +
	@git checkout go.mod

.PHONY: help
help: ## Display this help screen.
	@grep -E '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
