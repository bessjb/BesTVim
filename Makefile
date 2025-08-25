# Define variables
IMAGE_NAME=nvim
CONTAINER_NAME=nvim
DOCKERFILE_PATH=./Dockerfile
COMMAND=./my_binary # Replace with the command to run your binary if different
TEST_COMMAND=pytest # Replace with your actual test command if different

.PHONY: build_binary run_tests build_container enter_container clean

# Target for building a binary from a Docker container
build_binary:
	docker run --rm -v $(PWD):/app -w /app $(IMAGE_NAME) $(COMMAND)

# Target for running unit tests inside a Docker container
run_tests:
	docker run --rm -v $(PWD):/app -w /app $(IMAGE_NAME) $(TEST_COMMAND)

# Target for building the Docker container from a Dockerfile
build_container:
	docker build -t $(IMAGE_NAME) -f $(DOCKERFILE_PATH) .

# Target for entering an interactive shell in the Docker container
enter_container:
	docker run -it -v ./build:/root/build -v ./config:/root/.config/nvim -v /home/jake/Data/codebases/zotero-importer.nvim:/root/projects/zotero-importer.nvim nvim:latest /bin/bash


# Optional: Clean up any dangling images and unused containers
clean:
	docker system prune -f
