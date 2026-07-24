# AGENTS.md

## Repository purpose

This repository manages personal dotfiles and development tools for Ubuntu
24.04 LTS.

Changes may affect package installation, files under `$HOME`, shell startup,
Git configuration, and globally available command-line tools. Treat installer
changes as system-configuration changes rather than ordinary application code.

## Supported profiles

The installer accepts the following profiles:

* `dev`: CLI-focused development environment. This is the default profile.
* `host`: The `dev` environment plus physical-host-only components such as
  fonts and `tio`.

Keep common development tooling available in `dev`. Add a dependency to
`host` only when it is inappropriate or unnecessary in containers and remote
development environments.

When changing profile dependencies, verify that the relationship between
`config.dev.toml` and `config.host.toml` remains intentional.

## Important files

* `install.sh`

  * Installs required APT packages.
  * Installs `mise`.
  * Creates the dotfiles and mise configuration symlinks.
  * Runs the selected mise bootstrap task.
* `.config/mise/config.toml`

  * Defines shared tools, versions, environment variables, aliases, and
    dotfile links.
  * Treat this as the primary source of truth for shared development tools.
* `.config/mise/config.dev.toml`

  * Defines the `dev` bootstrap dependency set.
* `.config/mise/config.host.toml`

  * Defines the `host` bootstrap dependency set.
* `.config/mise/tasks/`

  * Contains implementation tasks used by the bootstrap profiles.
* `.config/bash/.bashrc.custom`

  * Contains interactive Bash configuration and functions.
* `.config/git/.gitconfig.custom`

  * Contains shared Git configuration.
* `.devcontainer/`

  * Provides the Ubuntu 24.04 development and preview environments.
* `.github/workflows/ci.yml`

  * Defines Docker, dev-container, host-profile, and idempotency checks.
* `README.md`

  * Documents user-facing installation procedures and supported features.

## Configuration conventions

Prefer the existing mise-based configuration mechanisms over adding unrelated
installation logic to `install.sh`.

Use:

* `[tools]` for tools managed by mise.
* `[env]` for environment variables.
* `[shell_alias]` for simple aliases.
* `[dotfiles]` for files, symlinks, and managed shell blocks.
* mise tasks for bootstrap operations that require commands or conditional
  logic.
* `install.sh` only for initial system prerequisites and mise bootstrap
  orchestration.

Do not add the same setting to multiple configuration layers unless the
duplication is required and documented.

Pin tool versions consistently with the existing entries. Do not silently
replace pinned versions with floating versions such as `latest`.

## Shell conventions

Shell scripts are Bash scripts.

* Use `#!/usr/bin/env bash` for executable Bash scripts.
* Use `set -euo pipefail` for non-trivial executable scripts unless there is a
  documented reason not to.
* Quote parameter expansions unless word splitting or glob expansion is
  intentional.
* Prefer `[[ ... ]]` for Bash string and file tests.
* Prefer `(( ... ))` for arithmetic conditions.
* Use `local` for function-local variables.
* Send error and warning output to standard error.
* Preserve the existing formatting style in surrounding code.
* Keep scripts safe to run more than once.

Do not introduce dependencies on shells other than Bash without updating the
documentation and CI environment.

## Safety rules

Do not run `./install.sh` directly on the user's host merely to validate a
change unless the user explicitly requests it.

The installer can:

* invoke `sudo`;
* install or update APT packages;
* install tools from the network;
* modify files and symlinks under `$HOME`;
* alter shell and Git behaviour.

Prefer static checks first. Perform full installation tests only in a
disposable Ubuntu 24.04 container, Dev Container, or CI environment.

Do not delete, overwrite, or migrate an existing user configuration without
an explicit compatibility or backup strategy.

Do not add secrets, credentials, tokens, SSH private keys, machine-specific
identifiers, or private paths to the repository.

## Validation

Run checks relevant to the changed files.

For Bash changes, run at least:

```bash
bash -n install.sh
```

Also run `bash -n` on each changed Bash script.

When ShellCheck is available, run it on changed shell files:

```bash
shellcheck install.sh
```

For mise configuration changes, inspect the affected profile and confirm that
all referenced tasks and files exist.

For installer, package, mise task, profile, or Dev Container changes, perform
a disposable-container build:

```bash
docker build \
  --target preview \
  --build-arg DOTFILES_PROFILE=dev \
  -f .devcontainer/Dockerfile \
  .
```

When the change affects `host`-only behaviour, also test:

```bash
docker build \
  --target preview \
  --build-arg DOTFILES_PROFILE=host \
  -f .devcontainer/Dockerfile \
  .
```

Installer changes must preserve idempotency. In an appropriate disposable
environment, run the selected profile twice and ensure the second execution
also succeeds.

If a full validation cannot be run because Docker, network access, sudo, or
another required facility is unavailable, report exactly which checks were
not run. Do not claim that the change is fully validated.

## Documentation

Update `README.md` when a change affects:

* installation commands;
* prerequisites;
* supported profiles;
* installed user-facing tools;
* environment variables or aliases users are expected to rely on;
* Dev Container or Docker usage;
* required post-installation steps.

Keep implementation details in code comments or focused documentation rather
than expanding the README unnecessarily.

## Change discipline

* Keep changes narrowly scoped to the requested task.
* Do not reformat unrelated files.
* Preserve backward compatibility unless the task explicitly requires a
  breaking change.
* Before changing a pinned tool version, inspect relevant release notes when
  network access is available.
* Do not modify generated caches, local histories, or machine-specific files.
* Review `git diff` before finishing.
* Clearly summarize behavioural changes and validation results.
