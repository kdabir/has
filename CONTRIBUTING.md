# Contributing to has

Thank you for your interest in contributing! Please follow these guidelines to get started.

## How to Run Locally

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kdabir/has.git
   cd has
   chmod +x ./has
   ```
2. **Run the main script:**
   ```bash
   ./has <command-names>
   ```
   Example:
   ```bash
   ./has git curl node
   ```

## How to Test Locally

### Unit Tests (run anywhere)
1. **Install dependencies:**
   - On Ubuntu:
     ```bash
     sudo apt-get update && sudo apt-get install -y bats make curl git
     ```
   - On Mac (using Homebrew):
     ```bash
     brew install bats-core make curl git
     ```
2. **Run the unit test suite:**
   ```bash
   make test
   # or
   bats tests/unit/unit-tests.bats
   ```

### Integration Tests (run in Docker)
1. **Build and run the Docker image** (see below for details)
2. **Run integration tests:**
   ```bash
   make test-intg
   # or
   bats -t tests/intg/test_all_packages.bats
   ```

You can also run individual test files with `bats tests/unit/unit-tests.bats` or `bats -t tests/intg/test_all_packages.bats` on both platforms.

## How to Run Tests Using Docker

If you don't have all dependencies/tools on your host, you can run tests inside a Docker container:

1. **Build the Docker image** (choose the appropriate Dockerfile, e.g., `ubuntu.Dockerfile`):
   ```bash
   docker build -f tests/containers/ubuntu.Dockerfile -t has-test-ubuntu .
   ```
2. **Run the tests inside the container:**
   ```bash
   docker run --rm -it has-test-ubuntu make test
   ```
   Or for all packages:
   ```bash
   docker run --rm -it has-test-ubuntu make test-intg
   ```
3. **(Optional) Mount your local code for development:**
   ```bash
   docker run --rm -it -v "$PWD":/workspace -w /workspace has-test-ubuntu bash
   # Then run tests interactively inside the container
   make test
   ```

This ensures a consistent environment and all required tools are available for testing.

## How to Add a Command and Add It to Docker Image

1. **Add support for a new command:**
   - Edit the `has` script and add your command to the `__detect` function or the relevant section.
   - Follow the pattern for similar commands.
2. **Test your change locally** (see above).
3. **Add the command to Docker images:**
   - Edit the relevant Dockerfile in `tests/containers/` (e.g., `ubuntu.Dockerfile`).
   - Add the package to the `apt-get install` or other relevant install section.
   - Build the Docker image locally to verify:
     ```bash
     docker build -f tests/containers/ubuntu.Dockerfile -t has-test-ubuntu .
     docker run --rm -it has-test-ubuntu
     ```

## How to Publish the Updated Docker Images

1. **Build the image:**
   ```bash
   docker build -f tests/containers/ubuntu.Dockerfile -t kdabir/has-test-containers:ubuntu .
   ```
2. **Login to Docker Hub:**
   ```bash
   docker login
   ```
3. **Push the image:**
   ```bash
   docker push kdabir/has-test-containers:ubuntu
   ```
   Replace `ubuntu` with the appropriate tag for other images.

---
For more details, see the main ./has file, test files and Dockerfile comments. If you have questions, open an issue or discussion!
