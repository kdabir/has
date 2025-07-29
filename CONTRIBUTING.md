# Contributing to has

Thank you for your interest in contributing! Please follow these guidelines to get started.

## How to run locally

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

## How to run tests locally

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

## Adding more tools

The current list of supported packages can be viewed with `make list`

If the command you wish to include supports any of `-v`, `--version`, `-version`, `version`, `-V` then you can find 
corresponding function which can be called to check presence and extract version. 

- commands that use `--version` flag -> `__dynamic_detect--version()` 
- commands that use `-version` flag -> `__dynamic_detect-version()`
- commands that use `-v` flag -> `__dynamic_detect-v()`
- commands that use `-V` flag -> `__dynamic_detect-V()`


However, for many tools version extraction may not work and you will need to add custom parsing of command's output. The `has` script is commented to guide developers about what needs to be done to add more tools. 

## Adding features

- If you are contributing a feature, please open an issue first to dicuss the idea. 
- When implmenting, ensure to check current tests. Add test cases for your feature. 
- Tests are executed using the excellent [bats](https://github.com/bats-core/bats-core) testing framework. 
- Add tests and run `make test`

Raise the PR and **make sure the tests pass** on [GitHub Actions](https://github.com/kdabir/has/actions).


## Looking for support to maintain docker based tests
I'm not expert at docker (or shell scripts for that matter). I need someone to look at `tests/to-fix` dir to help me
with integration tests for all tools installed in docker containers.

- `test_all_packages.bats` will test every package has supports. This includes newly added commands so please add new packages to
- `alpine.Dockerfile` and `ubuntu.Dockerfile` to install the tool OR
- `packages_alpine_skip.txt` and `packages_ubuntu_skip.txt` to exclude the package from the tests
