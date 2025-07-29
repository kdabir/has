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
3.  Install Prequisites for development

   ```bash
   ./has
   ```

   running `has` from root of the project tells you about the pre-requisites required  (because of `.hasrc` file)

## How to Test Locally

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

## Adding support for a tool

Look at existing checks in the `./has` file, basically you need to call one of the following:

- commands that use `--version` flag -> `__dynamic_detect--version()` 
- commands that use `-version` flag -> `__dynamic_detect-version()`
- commands that use `-v` flag -> `__dynamic_detect-v()`
- commands that use `-V` flag -> `__dynamic_detect-V()`


## Looking for support to maintain docker based tests
I'm not expert at docker (or shell scripts for that matter). I need someone to look at `tests/to-fix` dir to help me
with integration tests for all tools installed in docker containers.