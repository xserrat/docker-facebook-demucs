SHELL = /bin/sh
current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

model = htdemucs # default demucs model to use

.PHONY:
help: ## Display available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY:
run: ## Run demucs to split the specified track in the input folder
	docker run --rm -i \
		--name=demucs \
		-v $(current-dir)input:/data/input \
		-v $(current-dir)output:/data/output \
		-v $(current-dir)models:/data/models \
		xserrat/facebook-demucs:latest \
		"python3 -m demucs -n $(model) \
			--out /data/output \
			/data/input/$(track) \
			&& chmod 777 -R /data/output"

.PHONY:
run-interactive: ## Run the docker container interactively
	docker run --rm -it \
		--name=demucs-interactive \
		-v $(current-dir)input:/data/input \
		-v $(current-dir)output:/data/output \
		-v $(current-dir)models:/data/models \
		xserrat/facebook-demucs:latest \
		/bin/bash

.PHONY:
build: ## Build the default docker image which runs demucs using CPU only
	docker build --no-cache -t xserrat/facebook-demucs:latest -f Dockerfile.default .
