# Decisions

## 2026-11-09: Only the private-check from the repo standard, and not required

This tap holds generated formulae and is not on the owner's repo standard. Chose to add only the
two `private-check` workflows, `scripts/standard/private_check.py` and a `make private-check`
target, copied unchanged from repo-standard v0.17.0's public render; rejected adopting the whole
standard because a tap has nothing else for it to govern. Update those three files by copying a
later render over them; they are not edited in this repo.

The check runs on pull requests and on pushes to `main`, and no ruleset requires it. Chose to leave
the tap without a ruleset; rejected adding one because Annotary's release workflow pushes each
formula straight to `main` with a deploy key, and a required check would refuse that push.
