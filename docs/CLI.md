# CLI reference

Phase 1 introduces `dev-setup.sh` as the single command entry point. The
existing `setup-dev.sh` and `verify-setup.sh` scripts remain in place and
continue to perform the actual installation and verification work.

## Make the entry point executable\n\nAfter cloning the repository, run:\n\n```bash\nchmod +x dev-setup.sh\n```\n\nThen invoke it as shown below. You can alternatively run it with `bash dev-setup.sh`.\n\n## Commands

| Command | Behavior |
|---|---|
| `./dev-setup.sh help` | Display command help |
| `./dev-setup.sh version` | Display CLI version |
| `./dev-setup.sh system info` | Display basic OS and hardware information |
| `./dev-setup.sh install` | Delegate to the existing interactive installer |
| `./dev-setup.sh health check` | Delegate to the existing verifier |

## Important safety note

The `install` command delegates to the current legacy installer. That installer
can perform a full Pacman system upgrade and install a large package set.
Review its prompts and transaction carefully. Phase 1 does not implement
profiles, dry-run, package planning, or automatic repair.

## Tests

The CLI smoke tests use only Bash:

```bash
bash -n dev-setup.sh lib/common.sh tests/test_cli.sh
bash tests/test_cli.sh
```
